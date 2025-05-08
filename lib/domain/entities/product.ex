defmodule FoodOrderProducao.Domain.Entities.Product do
  @derive {Jason.Encoder, only: [:id, :name, :category, :price, :description, :preparation_time, :images]}
  defstruct [:id, name: nil, category: nil, price: nil, description: nil, preparation_time: nil, images: []]

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t() | nil,
          category: String.t() | nil,
          price: float() | nil,
          description: String.t() | nil,
          preparation_time: integer() | nil,
          images: list(String.t()) | nil
        }
end
