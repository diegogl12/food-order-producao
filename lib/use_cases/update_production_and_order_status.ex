defmodule FoodOrderProducao.UseCases.UpdateProductionAndOrderStatus do
  require Logger

  alias FoodOrderProducao.Domain.Entities.Production

  def execute(%Production{} = production, production_repository, order_client) do
    with {:ok, production} <- production_repository.update(production),
         {:ok, production} <- production_repository.get_by_order_id(production.order_id),
         :ok <- order_client.update_status(production) do
      {:ok, production}
    else
      {:error, error} ->
        Logger.error("Error on UpdateProductionAndOrderStatus.execute: #{inspect(error)}")
        {:error, error}
    end
  end
end
