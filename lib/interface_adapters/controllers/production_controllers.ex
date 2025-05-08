defmodule FoodOrderProducao.InterfaceAdapters.Controllers.ProductionController do
  require Logger

  alias FoodOrderProducao.InterfaceAdapters.DTOs.EventProductionDTO
  alias FoodOrderProducao.InterfaceAdapters.DTOs.WebProductionDTO
  alias FoodOrderProducao.InterfaceAdapters.Repositories.ProductionRepository
  alias FoodOrderProducao.InterfaceAdapters.Gateways.Clients.Pedidos, as: OrderGateway
  alias FoodOrderProducao.InterfaceAdapters.Gateways.Clients.Produtos, as: ProductGateway
  alias FoodOrderProducao.UseCases.InitializeProduction
  alias FoodOrderProducao.UseCases.UpdateProductionAndOrderStatus
  alias FoodOrderProducao.UseCases.GetProduction

  def initialize_production(production_json) do
    Logger.info("Initializing production: #{inspect(production_json)}")

    with {:ok, production_dto} <- EventProductionDTO.from_json(production_json),
         {:ok, production} <- EventProductionDTO.to_domain(production_dto) do
      InitializeProduction.execute(production, ProductionRepository)
    else
      {:error, error} ->
        Logger.error("Error on ProductionController.initialize production: #{inspect(error)}")
        {:error, error}
    end
  end

  def update_production_status(production_params) do
    Logger.info("Updating production status: #{inspect(production_params)}")

    with {:ok, production_dto} <- WebProductionDTO.from_map(production_params),
         {:ok, production} <- WebProductionDTO.to_domain(production_dto),
         {:ok, production} <- UpdateProductionAndOrderStatus.execute(production, ProductionRepository, OrderGateway) do
      {:ok, production}
    else
      {:error, error} ->
        Logger.error("Error on ProductionController.update_production_status: #{inspect(error)}")
        {:error, error}
    end
  end

  def get_production(order_id) do
    Logger.info("Getting production: #{inspect(order_id)}")

    case GetProduction.execute(order_id, ProductionRepository, ProductGateway) do
      {:ok, production} ->
        {:ok, production}
      {:error, :not_found} ->
        Logger.error("Production not found")
        {:error, :not_found}
      {:error, error} ->
        Logger.error("Error on ProductionController.get_production: #{inspect(error)}")
        {:error, error}
    end
  end
end
