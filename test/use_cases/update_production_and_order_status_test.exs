defmodule FoodOrderProducao.UseCases.UpdateProductionAndOrderStatusTest do
  use ExUnit.Case, async: true
  alias FoodOrderProducao.UseCases.UpdateProductionAndOrderStatus
  alias FoodOrderProducao.Domain.Entities.Production

  describe "execute/3" do
    setup do
      production = %Production{
        order_id: "order-123",
        status: "COMPLETED"
      }

      {:ok, production: production}
    end

    test "successfully updates production and order status", %{production: production} do
      MockProductionRepository
      |> Mox.expect(:get_by_order_id, fn "order-123" ->
        {:ok, %Production{order_id: "order-123", status: "PENDING"}}
      end)
      |> Mox.expect(:update, fn %Production{status: "COMPLETED"} ->
        {:ok, %Production{order_id: "order-123", status: "COMPLETED"}}
      end)

      MockOrderGateway
      |> Mox.expect(:update_status, fn %Production{status: "COMPLETED"} -> :ok end)

      result = UpdateProductionAndOrderStatus.execute(production, MockProductionRepository, MockOrderGateway)
      assert {:ok, %Production{status: "COMPLETED"}} = result
    end

    test "returns error when production is not found", %{production: production} do
      MockProductionRepository
      |> Mox.expect(:get_by_order_id, fn "order-123" -> {:error, :not_found} end)

      result = UpdateProductionAndOrderStatus.execute(production, MockProductionRepository, MockOrderGateway)
      assert {:error, :not_found} = result
    end

    test "returns error when update fails", %{production: production} do
      MockProductionRepository
      |> Mox.expect(:get_by_order_id, fn "order-123" ->
        {:ok, %Production{order_id: "order-123", status: "PENDING"}}
      end)
      |> Mox.expect(:update, fn _ -> {:error, :update_failed} end)

      result = UpdateProductionAndOrderStatus.execute(production, MockProductionRepository, MockOrderGateway)
      assert {:error, :update_failed} = result
    end

    test "returns error when order client update fails", %{production: production} do
      MockProductionRepository
      |> Mox.expect(:get_by_order_id, fn "order-123" ->
        {:ok, %Production{order_id: "order-123", status: "PENDING"}}
      end)
      |> Mox.expect(:update, fn %Production{status: "COMPLETED"} ->
        {:ok, %Production{order_id: "order-123", status: "COMPLETED"}}
      end)

      MockOrderGateway
      |> Mox.expect(:update_status, fn _ -> {:error, :client_error} end)

      result = UpdateProductionAndOrderStatus.execute(production, MockProductionRepository, MockOrderGateway)
      assert {:error, :client_error} = result
    end
  end
end
