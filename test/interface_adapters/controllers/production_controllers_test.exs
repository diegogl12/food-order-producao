defmodule FoodOrderProducao.InterfaceAdapters.Controllers.ProductionControllerTest do
  use ExUnit.Case, async: false
  use Mimic

  alias FoodOrderProducao.InterfaceAdapters.Controllers.ProductionController
  alias FoodOrderProducao.Domain.Entities.Production
  alias FoodOrderProducao.InterfaceAdapters.DTOs.EventProductionDTO
  alias FoodOrderProducao.InterfaceAdapters.DTOs.WebProductionDTO
  alias FoodOrderProducao.UseCases.InitializeProduction
  alias FoodOrderProducao.UseCases.UpdateProductionAndOrderStatus
  alias FoodOrderProducao.UseCases.GetProduction

  setup :set_mimic_global
  setup :verify_on_exit!

  setup do
    production_json = ~s({"order_id": "order-123", "status": "PENDING"})
    production_params = %{"order_id" => "order-123", "status" => "COMPLETED"}

    {:ok, production_json: production_json, production_params: production_params}
  end

  describe "initialize_production/1" do
    test "successfully initializes production", %{production_json: production_json} do
      EventProductionDTO
      |> stub(:from_json, fn _ -> {:ok, %EventProductionDTO{order_id: "order-123", status: "PENDING"}} end)
      |> stub(:to_domain, fn _ -> {:ok, %Production{order_id: "order-123", status: "PENDING"}} end)

      InitializeProduction
      |> stub(:execute, fn _, _ -> {:ok, %Production{order_id: "order-123", status: "PENDING"}} end)

      assert {:ok, %Production{order_id: "order-123", status: "PENDING"}} =
               ProductionController.initialize_production(production_json)
    end

    test "returns error when DTO conversion fails", %{production_json: production_json} do
      EventProductionDTO
      |> stub(:from_json, fn _ -> {:error, "Invalid event production data"} end)

      assert {:error, "Invalid event production data"} = ProductionController.initialize_production(production_json)
    end
  end

  describe "update_production_status/1" do
    test "successfully updates production status", %{production_params: production_params} do
      WebProductionDTO
      |> stub(:from_map, fn _ -> {:ok, %Production{order_id: "order-123", status: "COMPLETED"}} end)
      |> stub(:to_domain, fn _ -> {:ok, %Production{order_id: "order-123", status: "COMPLETED"}} end)

      UpdateProductionAndOrderStatus
      |> stub(:execute, fn _, _, _ -> {:ok, %Production{order_id: "order-123", status: "COMPLETED"}} end)

      assert {:ok, %Production{order_id: "order-123", status: "COMPLETED"}} =
               ProductionController.update_production_status(production_params)
    end

    test "returns error when DTO conversion fails", %{production_params: production_params} do
      WebProductionDTO
      |> stub(:from_map, fn _ -> {:error, "Invalid web production data"} end)

      assert {:error, "Invalid web production data"} =
               ProductionController.update_production_status(production_params)
    end
  end

  describe "get_production/1" do
    test "successfully retrieves production" do
      GetProduction
      |> stub(:execute, fn _, _, _ -> {:ok, %Production{order_id: "order-123", status: "PENDING"}} end)

      assert {:ok, %Production{order_id: "order-123", status: "PENDING"}} =
               ProductionController.get_production("order-123")
    end

    test "returns error when production is not found" do
      GetProduction
      |> stub(:execute, fn _, _, _ -> {:error, "Production not found"} end)

      assert {:error, "Production not found"} =
               ProductionController.get_production("order-123")
    end
  end
end
