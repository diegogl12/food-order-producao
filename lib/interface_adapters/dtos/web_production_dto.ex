defmodule FoodOrderProducao.InterfaceAdapters.DTOs.WebProductionDTO do
  alias FoodOrderProducao.Domain.Entities.Production

  defstruct [:order_id, :product_ids, :products, :created_at, :status]

  @type t :: %__MODULE__{
          order_id: String.t(),
          product_ids: [String.t()] | [],
          products: [String.t()] | [],
          created_at: NaiveDateTime.t() | nil,
          status: String.t() | nil
        }

  def from_map(map) do
    map_with_atoms =
      map
      |> Enum.map(fn {key, value} ->
        {String.to_existing_atom(key), value}
      end)
      |> Map.new()

    result = %__MODULE__{
      order_id: Map.get(map_with_atoms, :order_id),
      product_ids: Map.get(map_with_atoms, :product_ids, []),
      products: Map.get(map_with_atoms, :products, []),
      created_at: Map.get(map_with_atoms, :created_at),
      status: Map.get(map_with_atoms, :status)
    }

    {:ok, result}
  end

  def to_domain(%__MODULE__{} = dto) do
    result = %Production{
      order_id: dto.order_id,
      product_ids: dto.product_ids,
      products: dto.products,
      created_at: dto.created_at,
      status: dto.status
    }

    {:ok, result}
  end
end
