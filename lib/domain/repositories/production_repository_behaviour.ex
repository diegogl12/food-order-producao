defmodule FoodOrderProducao.Domain.Repositories.ProductionRepositoryBehaviour do
  alias FoodOrderProducao.Domain.Entities.Production

  @callback create(Production.t()) :: {:ok, Production.t()} | {:error, any()}
  @callback update(Production.t()) :: {:ok, Production.t()} | {:error, any()}
  @callback get_by_order_id(String.t()) :: {:ok, Production.t()} | {:error, any()}
end
