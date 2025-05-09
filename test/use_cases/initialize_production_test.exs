defmodule FoodOrderProducao.UseCases.InitializeProductionTest do
  use ExUnit.Case, async: true
  alias FoodOrderProducao.UseCases.InitializeProduction
  alias FoodOrderProducao.Domain.Entities.Production

  describe "execute/2" do
    setup do
      production = %Production{
        order_id: "order-123",
        product_ids: ["product-1", "product-2"],
        created_at: ~U[2021-01-01 00:00:00Z],
        status: "PENDING"
      }

      {:ok, production: production}
    end

    test "successfully initializes production with pending status", %{production: production} do
      MockProductionRepository
      |> Mox.expect(:create, fn _ ->
        {:ok, Map.put(production, :status, "PENDING")}
      end)

      result = InitializeProduction.execute(production, MockProductionRepository)
      assert {:ok, %Production{status: "PENDING"}} = result
    end

    test "returns error when production creation fails", %{production: production} do
      MockProductionRepository
      |> Mox.expect(:create, fn _ -> {:error, :database_error} end)

      result = InitializeProduction.execute(production, MockProductionRepository)
      assert {:error, :database_error} = result
    end
  end
end
