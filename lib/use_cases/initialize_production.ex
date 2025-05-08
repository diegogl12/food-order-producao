defmodule FoodOrderProducao.UseCases.InitializeProduction do
  require Logger
  alias FoodOrderProducao.Domain.Entities.Production

  @callback execute(Production.t(), ProductionRepository.t()) :: {:ok, Production.t()} | {:error, String.t()}
  def execute(%Production{} = production, production_repository) do
    with production <- set_pending_status(production),
        {:ok, production} <- production_repository.create(production) do
      {:ok, production}
    else
      {:error, error} ->
        Logger.error("Error on InitializeProduction.execute: #{inspect(error)}")
        {:error, error}
    end
  end

  defp set_pending_status(production) do
    production
    |> Map.put(:status, "PENDING")
    |> Map.put(:created_at, DateTime.utc_now())
  end
end
