defmodule FoodOrderProducao.InterfaceAdapters.Repositories.Schemas.ProductionSchema do
    @moduledoc false
    use Mongo.Collection

    alias BSON.Binary

    collection :s do
        attribute :order_id, Binary.t()
        attribute :product_ids, :array, default: []
        attribute :products, :array, default: []
        attribute :created_at, :datetime, default: DateTime.utc_now()
        attribute :status, :string, default: "PENDENTE"
    end

    def new(production) do
        Map.put(new(), :order_id, production.order_id)
        |> Map.put(:product_ids, production.product_ids)
        |> Map.put(:products, production.products)
        |> Map.put(:created_at, production.created_at)
        |> Map.put(:status, production.status)
    end
end
