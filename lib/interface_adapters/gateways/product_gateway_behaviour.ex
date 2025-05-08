defmodule FoodOrderProducao.InterfaceAdapters.Gateways.ProductGatewayBehaviour do
  alias FoodOrderProducao.Domain.Entities.Production

  @callback get_products(product_ids :: list(String.t())) :: {:ok, list(Product.t())} | {:error, any()}
end
