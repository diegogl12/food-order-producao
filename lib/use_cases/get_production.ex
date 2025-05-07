defmodule FoodOrderProducao.UseCases.GetProduction do
  require Logger

  alias FoodOrderProducao.Domain.Entities.Production

  def execute(order_id, production_repository, product_gateway) do
    with {:ok, %Production{product_ids: product_ids} = production} <- production_repository.get_by_order_id(order_id),
         {:ok, products} <- product_gateway.get_products(product_ids),
         result_production <- add_products_to_production(production, products) do
      {:ok, result_production}
    end
  end

  defp add_products_to_production(production, products) do
    production
    |> Map.put(:products, products)
  end
end
