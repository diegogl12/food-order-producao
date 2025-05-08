defmodule FoodOrderProducao.UseCases.GetProductionTest do
  use ExUnit.Case, async: true

  alias FoodOrderProducao.UseCases.GetProduction
  alias FoodOrderProducao.Domain.Entities.Production

  describe "execute/3" do
    test "returns the production with products when successful" do
      order_id = "order-123"
      product_ids = ["product-1", "product-2"]

      production = %Production{
        order_id: order_id,
        product_ids: product_ids,
        status: "pending"
      }

      products = [
        %{id: "product-1", name: "Burger", price: 10.0},
        %{id: "product-2", name: "Fries", price: 5.0}
      ]

      MockProductionRepository
      |> Mox.expect(:get_by_order_id, fn ^order_id -> {:ok, production} end)

      MockProductGateway
      |> Mox.expect(:get_products, fn ^product_ids -> {:ok, products} end)

      result = GetProduction.execute(order_id, MockProductionRepository, MockProductGateway)

      # Assert the result
      assert {:ok, expected_production} = result
      assert expected_production.products == products
    end

    test "returns error when production is not found" do
      order_id = "non-existent-order"

      # Mock repository to return error
      MockProductionRepository
      |> Mox.expect(:get_by_order_id, fn ^order_id -> {:error, :not_found} end)

      # Product gateway should not be called
      MockProductGateway
      |> Mox.stub(:get_products, fn _product_ids -> {:ok, []} end)

      result = GetProduction.execute(order_id, MockProductionRepository, MockProductGateway)
      assert result == {:error, :not_found}
    end

    test "returns error when products cannot be fetched" do
      order_id = "order-123"
      product_ids = ["product-1", "product-2"]

      production = %Production{
        order_id: order_id,
        product_ids: product_ids,
        status: "pending"
      }

      # Mock repository to return success
      MockProductionRepository
      |> Mox.expect(:get_by_order_id, fn ^order_id -> {:ok, production} end)

      # Mock gateway to return error
      MockProductGateway
      |> Mox.expect(:get_products, fn ^product_ids -> {:error, :service_unavailable} end)

      result = GetProduction.execute(order_id, MockProductionRepository, MockProductGateway)
      assert result == {:error, :service_unavailable}
    end
  end
end
