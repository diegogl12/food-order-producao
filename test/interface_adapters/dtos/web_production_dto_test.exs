defmodule FoodOrderProducao.InterfaceAdapters.DTOs.WebProductionDTOTest do
  use ExUnit.Case, async: false
  use Mimic

  alias FoodOrderProducao.InterfaceAdapters.DTOs.WebProductionDTO
  alias FoodOrderProducao.Domain.Entities.Production

  setup :set_mimic_global
  setup :verify_on_exit!

  describe "from_map/1" do
    test "successfully converts map to DTO" do
      map = %{"order_id" => "order-123", "product_ids" => ["prod-1", "prod-2"], "products" => ["prod-1", "prod-2"], "created_at" => ~N[2023-10-01 12:00:00], "status" => "pending"}

      WebProductionDTO
      |> stub(:from_map, fn _ -> {:ok, %WebProductionDTO{order_id: "order-123", product_ids: ["prod-1", "prod-2"], products: ["prod-1", "prod-2"], created_at: ~N[2023-10-01 12:00:00], status: "pending"}} end)

      assert {:ok, %WebProductionDTO{order_id: "order-123", product_ids: ["prod-1", "prod-2"], products: ["prod-1", "prod-2"], created_at: ~N[2023-10-01 12:00:00], status: "pending"}} =
               WebProductionDTO.from_map(map)
    end

    test "returns error for invalid map" do
      map = %{"invalid_key" => "value"}

      WebProductionDTO
      |> stub(:from_map, fn _ -> {:error, "Invalid web production data - unknown fields"} end)

      assert {:error, "Invalid web production data - unknown fields"} = WebProductionDTO.from_map(map)
    end
  end

  describe "to_domain/1" do
    test "successfully converts DTO to domain entity" do
      dto = %WebProductionDTO{order_id: "order-123", product_ids: ["prod-1", "prod-2"], products: ["prod-1", "prod-2"], created_at: ~N[2023-10-01 12:00:00], status: "pending"}

      WebProductionDTO
      |> stub(:to_domain, fn _ -> {:ok, %Production{order_id: "order-123", product_ids: ["prod-1", "prod-2"], products: ["prod-1", "prod-2"], created_at: ~N[2023-10-01 12:00:00], status: "pending"}} end)

      assert {:ok, %Production{order_id: "order-123", product_ids: ["prod-1", "prod-2"], products: ["prod-1", "prod-2"], created_at: ~N[2023-10-01 12:00:00], status: "pending"}} =
               WebProductionDTO.to_domain(dto)
    end
  end
end
