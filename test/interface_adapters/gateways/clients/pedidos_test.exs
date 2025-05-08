defmodule FoodOrderProducao.InterfaceAdapters.Gateways.Clients.PedidosTest do
  use ExUnit.Case, async: true
  import Mock

  alias FoodOrderProducao.InterfaceAdapters.Gateways.Clients.Pedidos

  describe "update_status/1" do
    test "successfully updates status with a 2xx response" do
      production = %{order_id: "order-123", status: "completed"}

      with_mock Tesla,
      [
        put: fn _, _, _ -> {:ok, %{status: 200, body: ""}} end,
        client: fn _ -> [] end
      ] do
        assert :ok = Pedidos.update_status(production)
      end
    end

    test "returns error with a non-2xx response" do
      production = %{order_id: "order-123", status: "completed"}

      with_mock Tesla, [
        put: fn _, _, _ -> {:ok, %{status: 400, body: "Bad Request"}} end,
        client: fn _ -> [] end
      ] do
        assert {:error, "Bad Request"} = Pedidos.update_status(production)
      end
    end

    test "returns error when request fails" do
      production = %{order_id: "order-123", status: "completed"}

      with_mock Tesla, [
        put: fn _, _, _ -> {:error, "Network Error"} end,
        client: fn _ -> [] end
      ] do
        assert {:error, "Network Error"} = Pedidos.update_status(production)
      end
    end
  end
end
