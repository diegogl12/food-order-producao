defmodule FoodOrderProducao.Domain.Entities.Production do
  alias FoodOrderProducao.Domain.Entities.Product

  @derive {Jason.Encoder, only: [:order_id, :product_ids, :products, :created_at, :status]}
  defstruct [order_id: nil, product_ids: [], products: [], created_at: nil, status: "PENDENTE"]

  @type t :: %__MODULE__{
          order_id: String.t(),
          product_ids: [String.t()] | [],
          products: [Product.t()] | [],
          created_at: NaiveDateTime.t() | nil,
          status: String.t()
        }

  def new(attrs) do
    production =
      struct(
        __MODULE__,
        Map.merge(attrs, %{
          created_at: NaiveDateTime.utc_now()
        })
      )

    {:ok, production}
  end
end
