defmodule FoodOrderProducao.InterfaceAdapters.DTOs.EventProductionDTO do
  alias FoodOrderProducao.Domain.Entities.Production

  defstruct [:order_id, :product_ids, :created_at, :status]

  @type t :: %__MODULE__{
          order_id: String.t(),
          product_ids: [String.t()] | [],
          created_at: NaiveDateTime.t() | nil,
          status: String.t() | nil
        }

  @callback from_json(String.t()) :: {:ok, t()} | {:error, String.t()}
  def from_json(json) do
    with {:ok, data} <- Jason.decode(json),
         {:ok, dto} <- from_event_production_map(data) do
      {:ok, dto}
    end
  end

  @callback from_event_production_map(map()) :: {:ok, t()} | {:error, String.t()}
  def from_event_production_map(map) when is_map(map) do
    map_with_atoms =
      map
      |> Enum.map(fn {key, value} ->
        {String.to_existing_atom(key), value}
      end)
      |> Map.new()

    dto = %__MODULE__{
      order_id: map_with_atoms.numero_pedido,
      product_ids: map_with_atoms.lista_produtos
    }
    {:ok, dto}
  rescue
    ArgumentError -> {:error, "Invalid event production data - unknown fields"}
    _ -> {:error, "Invalid event production data"}
  end

  @callback from_map(map()) :: {:ok, t()} | {:error, String.t()}
  def from_map(map) when is_map(map) do
    map_with_atoms = map
    |> Enum.map(fn {key, value} ->
      {String.to_existing_atom(key), value}
    end)

    dto = %__MODULE__{
      order_id: Map.get(map_with_atoms, :numero_pedido),
      product_ids: Map.get(map_with_atoms, :lista_produtos, []),
      created_at: Map.get(map_with_atoms, :created_at),
      status: Map.get(map_with_atoms, :status)
    }
    {:ok, dto}
  end

  @callback to_domain(t()) :: {:ok, Production.t()}
  def to_domain(%__MODULE__{} = dto) do
    {:ok, %Production{
      order_id: dto.order_id,
      product_ids: dto.product_ids,
      created_at: NaiveDateTime.utc_now(),
      status: nil
    }}
  end
end
