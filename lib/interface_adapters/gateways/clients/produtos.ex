defmodule FoodOrderProducao.InterfaceAdapters.Gateways.Clients.Produtos do
  @behaviour FoodOrderProducao.InterfaceAdapters.Gateways.ProductGatewayBehaviour

  alias FoodOrderProducao.Domain.Entities.Product

  @impl true
  def get_products([_ | _] = product_ids) do
    body = Jason.encode!(product_ids)

    client()
    |> Tesla.get("/Produtos/ObterPorIds", body: body)
    |> case do
      {:ok, %{status: status, body: body}} when status >= 200 and status < 300 ->
        {:ok, to_domain(body)}
      error ->
        {:error, error}
    end
  end

  def get_products([]), do: {:error, "No product ids provided"}

  defp to_domain(body) do
    body
    |> Enum.map(
      fn raw_product ->
        %Product{
          id: raw_product["id"],
          name: raw_product["nome"],
          category: raw_product["tipo"],
          price: raw_product["preco"],
          description: raw_product["descricao"],
          preparation_time: raw_product["tempoPreparo"],
          images: to_domain_images(raw_product["imagens"])
        }
      end
    )
  end

  defp to_domain_images(images) when is_list(images), do: Enum.map(images, & Jason.encode!(&1))
  defp to_domain_images(_), do: []

  defp client do
    Tesla.client([
      {Tesla.Middleware.BaseUrl, get_host()},
      {Tesla.Middleware.JSON, []}
    ])
  end

  defp get_host do
    Application.get_env(:food_order_producao, :produtos)[:host]
  end
end
