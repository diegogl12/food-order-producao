defmodule FoodOrderProducao.InterfaceAdapters.Repositories.ProductionRepository do
  require Logger

  @behaviour FoodOrderProducao.Domain.Repositories.ProductionRepositoryBehaviour

  alias FoodOrderProducao.Infra.Repo.Mongo
  alias FoodOrderProducao.Domain.Entities.Production
  alias FoodOrderProducao.InterfaceAdapters.Repositories.Schemas.ProductionSchema

  @impl true
  def create(%Production{} = production) do
    ProductionSchema.new(production)
    |> Mongo.insert()
    |> case do
      {:ok, _} ->
        {:ok, production}

      {:error, error} ->
        {:error, error}
    end
  end

  @impl true
  def update(%Production{} = new_production) do
    with old_production_schema <- Mongo.get_by(ProductionSchema, %{order_id: new_production.order_id}),
         new_production_schema <- %{ProductionSchema.new(new_production) | _id: old_production_schema._id},
         new_production_schema <- Map.merge(old_production_schema, new_production_schema),
         {:ok, result_production_schema} <- Mongo.update(new_production_schema) do
      {:ok, to_production(result_production_schema)}
    end
  end

  @impl true
  def get_by_order_id(order_id) do
    case Mongo.get_by(ProductionSchema, %{order_id: order_id}) do
      nil ->
        {:error, :not_found}
      {:error, error} ->
        {:error, error}
      production ->
        {:ok, to_production(production)}
    end
  end

  defp to_production(production_schema) do
    %Production{
      order_id: Map.get(production_schema, :order_id),
      product_ids: Map.get(production_schema, :product_ids),
      products: Map.get(production_schema, :products),
      created_at: Map.get(production_schema, :created_at),
      status: Map.get(production_schema, :status)
    }
  end
end
