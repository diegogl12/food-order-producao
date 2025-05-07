defmodule FoodOrderProducao.InterfaceAdapters.Gateways.Clients.Pedidos do
  @behaviour FoodOrderProducao.InterfaceAdapters.Gateways.OrderGatewayBehavior

  @impl true
  def update_status(production) do
      client()
      |> Tesla.put("/pedidos/atualizarStatusPedido", %{
        order_id: production.order_id,
        status: production.status
      })
    |> case do
      {:ok, %{status: status, body: _body}} when status >= 200 and status < 300 ->
        :ok

      {:ok, %{status: _status, body: body}} ->
        {:error, body}
    end
  end

  defp client do
    Tesla.client([
      {Tesla.Middleware.BaseUrl, get_host()},
      {Tesla.Middleware.JSON, []}
    ])
  end

  defp get_host do
    Application.get_env(:food_order_producao, :pedidos)[:host]
  end
end
