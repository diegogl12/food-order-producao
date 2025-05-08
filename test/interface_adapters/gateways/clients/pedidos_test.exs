defmodule FoodOrderProducao.InterfaceAdapters.Gateways.Clients.PedidosTest do
  use ExUnit.Case, async: false
  use Mimic

  alias FoodOrderProducao.InterfaceAdapters.Gateways.Clients.Pedidos

  # Garante que as expectativas sejam verificadas no fim do teste
  setup :set_mimic_global
  setup :verify_on_exit!

  describe "update_status/1" do
    test "successfully updates status with a 2xx response" do
      production = %{order_id: "order-123", status: "completed"}

      Tesla
      |> stub(:put, fn _, _, _ -> {:ok, %{status: 200, body: ""}} end)
      |> stub(:client, fn _ -> [] end)

      assert :ok = Pedidos.update_status(production)
    end

    test "returns error with a non-2xx response" do
      production = %{order_id: "order-123", status: "completed"}

      Tesla
      |> stub(:put, fn _, _, _ -> {:ok, %{status: 400, body: "Bad Request"}} end)
      |> stub(:client, fn _ -> [] end)

      assert {:error, "Bad Request"} = Pedidos.update_status(production)
    end

    test "returns error when request fails" do
      production = %{order_id: "order-123", status: "completed"}

      Tesla
      |> stub(:put, fn _, _, _ -> {:error, "Network Error"} end)
      |> stub(:client, fn _ -> [] end)

      assert {:error, "Network Error"} = Pedidos.update_status(production)
    end
  end
end
