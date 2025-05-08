defmodule FoodOrderProducao.InterfaceAdapters.DTOs.EventProductionDTOTest do
  use ExUnit.Case, async: true
  import Mock

  alias FoodOrderProducao.InterfaceAdapters.DTOs.EventProductionDTO
  alias FoodOrderProducao.Domain.Entities.Production

  describe "from_json/1" do
    test "successfully converts JSON to DTO" do
      json = ~s({"numero_pedido": "order-123", "lista_produtos": ["prod-1", "prod-2"]})

      with_mock Jason, [decode: fn _ -> {:ok, %{"numero_pedido" => "order-123", "lista_produtos" => ["prod-1", "prod-2"]}} end] do
        assert {:ok, %EventProductionDTO{order_id: "order-123", product_ids: ["prod-1", "prod-2"]}} =
                 EventProductionDTO.from_json(json)
      end
    end

    test "returns error for invalid JSON" do
      json = ~s({"invalid_json": "missing_fields"})

      with_mock Jason, [decode: fn _ -> {:ok, %{"invalid_json" => "missing_fields"}} end] do
        assert {:error, "Invalid event production data - unknown fields"} = EventProductionDTO.from_json(json)
      end
    end
  end

  describe "to_domain/1" do
    test "successfully converts DTO to domain entity" do
      dto = %EventProductionDTO{order_id: "order-123", product_ids: ["prod-1", "prod-2"]}

      assert {:ok, %Production{order_id: "order-123", product_ids: ["prod-1", "prod-2"], created_at: _, status: nil}} =
               EventProductionDTO.to_domain(dto)
    end
  end
end
