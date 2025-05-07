defmodule FoodOrderProducao.InterfaceAdapters.Gateways.OrderGatewayBehaviour do
  alias FoodOrderProducao.Domain.Entities.Production

  @callback update_status(Production.t()) :: :ok | {:error, any()}
end
