defmodule FoodOrderProducao.Infra.Web.Controllers.ProductionController do
  require Logger

  alias FoodOrderProducao.InterfaceAdapters.Controllers.ProductionController

  @doc """
  Updates the production status of a production.

  params:
   - order_id: string
   - status: string
  """
  def update_production_status(params) do
    Logger.info("Updating production status: #{inspect(params)}")

    ProductionController.update_production_status(params)
  end

  def get_production(order_id) do
    Logger.info("Getting production with order_id: #{inspect(order_id)}")

    ProductionController.get_production(order_id)
  end
end
