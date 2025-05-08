defmodule FoodOrderProducao.Infra.Web.Controllers.ProductionControllerTest do
  use ExUnit.Case, async: false
  use Mimic

  alias FoodOrderProducao.Infra.Web.Controllers.ProductionController
  alias FoodOrderProducao.InterfaceAdapters.Controllers.ProductionController, as: InterfaceController

  setup :set_mimic_global
  setup :verify_on_exit!

  describe "update_production_status/1" do
    test "successfully updates production status" do
      params = %{order_id: "order-123", status: "completed"}

      InterfaceController
      |> stub(:update_production_status, fn _ -> :ok end)

      assert :ok = ProductionController.update_production_status(params)
    end

    test "returns error when update fails" do
      params = %{order_id: "order-123", status: "completed"}

      InterfaceController
      |> stub(:update_production_status, fn _ -> {:error, "Update Error"} end)

      assert {:error, "Update Error"} = ProductionController.update_production_status(params)
    end
  end

  describe "get_production/1" do
    test "successfully retrieves production" do
      order_id = "order-123"
      production = %{order_id: order_id, status: "pending"}

      InterfaceController
      |> stub(:get_production, fn _ -> {:ok, production} end)

      assert {:ok, ^production} = ProductionController.get_production(order_id)
    end

    test "returns error when production not found" do
      order_id = "order-123"

      InterfaceController
      |> stub(:get_production, fn _ -> {:error, :not_found} end)

      assert {:error, :not_found} = ProductionController.get_production(order_id)
    end

    test "returns error when retrieval fails" do
      order_id = "order-123"

      InterfaceController
      |> stub(:get_production, fn _ -> {:error, "Retrieval Error"} end)

      assert {:error, "Retrieval Error"} = ProductionController.get_production(order_id)
    end
  end
end
