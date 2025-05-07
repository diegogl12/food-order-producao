defmodule FoodOrderProducao.InterfaceAdapters.Gateways.ProductGatewayBehaviour do
  alias FoodOrderProducao.Domain.Entities.Production

  @callback get_products() :: {:ok, list(Product.t())} | {:error, any()}
end
