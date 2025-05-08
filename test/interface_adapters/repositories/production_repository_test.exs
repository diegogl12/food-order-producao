defmodule FoodOrderProducao.InterfaceAdapters.Repositories.ProductionRepositoryTest do
  use ExUnit.Case, async: true
  import Mock

  alias FoodOrderProducao.InterfaceAdapters.Repositories.ProductionRepository
  alias FoodOrderProducao.Domain.Entities.Production

  describe "create/1" do
    test "successfully creates a production" do
      production = %Production{order_id: "order-123", product_ids: ["prod-1"], products: [], created_at: ~N[2023-10-01 12:00:00], status: "pending"}

      with_mock FoodOrderProducao.Infra.Repo.Mongo, [insert: fn _ -> {:ok, %{}} end] do
        assert {:ok, ^production} = ProductionRepository.create(production)
      end
    end

    test "returns error when creation fails" do
      production = %Production{order_id: "order-123", product_ids: ["prod-1"], products: [], created_at: ~N[2023-10-01 12:00:00], status: "pending"}

      with_mock FoodOrderProducao.Infra.Repo.Mongo, [insert: fn _ -> {:error, "Insertion Error"} end] do
        assert {:error, "Insertion Error"} = ProductionRepository.create(production)
      end
    end
  end

  describe "update/1" do
    test "successfully updates a production" do
      old_production_schema = %{_id: "some-id", order_id: "order-123", product_ids: ["prod-1"], products: [], created_at: ~N[2023-10-01 12:00:00], status: "completed"}
      new_production = %Production{order_id: "order-123", product_ids: ["prod-1"], products: [], created_at: ~N[2023-10-01 12:00:00], status: "completed"}

      with_mock FoodOrderProducao.Infra.Repo.Mongo, [
        get_by: fn _, _ -> old_production_schema end,
        update: fn _ -> {:ok, old_production_schema} end
      ] do
        assert {:ok, ^new_production} = ProductionRepository.update(new_production)
      end
    end

    test "returns error when update fails" do
      old_production_schema = %{_id: "some-id", order_id: "order-123"}
      new_production = %Production{order_id: "order-123", product_ids: ["prod-1"], products: [], created_at: ~N[2023-10-01 12:00:00], status: "completed"}

      with_mock FoodOrderProducao.Infra.Repo.Mongo, [
        get_by: fn _, _ -> old_production_schema end,
        update: fn _ -> {:error, "Update Error"} end
      ] do
        assert {:error, "Update Error"} = ProductionRepository.update(new_production)
      end
    end
  end

  describe "get_by_order_id/1" do
    test "successfully retrieves a production by order_id" do
      production_schema = %{order_id: "order-123", product_ids: ["prod-1"], products: [], created_at: ~N[2023-10-01 12:00:00], status: "pending"}

      with_mock FoodOrderProducao.Infra.Repo.Mongo, [get_by: fn _, _ -> production_schema end] do
        assert {:ok, %Production{order_id: "order-123"}} = ProductionRepository.get_by_order_id("order-123")
      end
    end

    test "returns error when production not found" do
      with_mock FoodOrderProducao.Infra.Repo.Mongo, [get_by: fn _, _ -> nil end] do
        assert {:error, :not_found} = ProductionRepository.get_by_order_id("order-123")
      end
    end

    test "returns error when retrieval fails" do
      with_mock FoodOrderProducao.Infra.Repo.Mongo, [get_by: fn _, _ -> {:error, "Retrieval Error"} end] do
        assert {:error, "Retrieval Error"} = ProductionRepository.get_by_order_id("order-123")
      end
    end
  end
end
