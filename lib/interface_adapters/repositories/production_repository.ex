defmodule FoodOrderProducao.InterfaceAdapters.Repositories.ProductionRepository do
  require Logger

  @behaviour FoodOrderProducao.Domain.Repositories.ProductionRepositoryBehaviour

  alias FoodOrderProducao.Domain.Entities.Production

  @impl true
  def create(%Production{} = production) do
    {:ok, production}
  end

  @impl true
  def update(%Production{} = production) do
    {:ok, production}
  end

  @impl true
  def get_by_order_id(order_id) do
    {:ok, %Production{}}
  end
end
