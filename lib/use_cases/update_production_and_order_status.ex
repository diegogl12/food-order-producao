defmodule FoodOrderProducao.UseCases.UpdateProductionAndOrderStatus do
  require Logger

  alias FoodOrderProducao.Domain.Entities.Production

  def execute(%Production{} = production, production_repository, order_client) do
    with {:ok, %Production{} = old_production} <- production_repository.get_by_order_id(production.order_id),
        new_production <- %Production{old_production | status: production.status},
         {:ok, result_production} <- production_repository.update(new_production),
         :ok <- order_client.update_status(result_production) do
      {:ok, result_production}
    else
      {:error, error} ->
        Logger.error("Error on UpdateProductionAndOrderStatus.execute: #{inspect(error)}")
        {:error, error}
    end
  end
end
