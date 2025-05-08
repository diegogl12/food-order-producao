defmodule FoodOrderProducao.Infra.Web.Controllers.ProductionControllerTest do
  use ExUnit.Case, async: true
  import Mock

  alias FoodOrderProducao.Infra.Web.Controllers.ProductionController
  alias FoodOrderProducao.InterfaceAdapters.Controllers.ProductionController, as: InterfaceController

  describe "update_production_status/1" do
    test "successfully updates production status" do
      params = %{order_id: "order-123", status: "completed"}

      with_mock InterfaceController, [update_production_status: fn _ -> :ok end] do
        assert :ok = ProductionController.update_production_status(params)
      end
    end

    test "returns error when update fails" do
      params = %{order_id: "order-123", status: "completed"}

      with_mock InterfaceController, [update_production_status: fn _ -> {:error, "Update Error"} end] do
        assert {:error, "Update Error"} = ProductionController.update_production_status(params)
      end
    end
  end

  describe "get_production/1" do
    test "successfully retrieves production" do
      order_id = "order-123"
      production = %{order_id: order_id, status: "pending"}

      with_mock InterfaceController, [get_production: fn _ -> {:ok, production} end] do
        assert {:ok, ^production} = ProductionController.get_production(order_id)
      end
    end

    test "returns error when production not found" do
      order_id = "order-123"

      with_mock InterfaceController, [get_production: fn _ -> {:error, :not_found} end] do
        assert {:error, :not_found} = ProductionController.get_production(order_id)
      end
    end

    test "returns error when retrieval fails" do
      order_id = "order-123"

      with_mock InterfaceController, [get_production: fn _ -> {:error, "Retrieval Error"} end] do
        assert {:error, "Retrieval Error"} = ProductionController.get_production(order_id)
      end
    end
  end
end
