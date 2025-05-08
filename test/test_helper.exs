ExUnit.start()
Application.ensure_all_started(:mimic)

Mox.defmock(MockProductionRepository, for: FoodOrderProducao.Domain.Repositories.ProductionRepositoryBehaviour)
Mox.defmock(MockProductGateway, for: FoodOrderProducao.InterfaceAdapters.Gateways.ProductGatewayBehaviour)
Mox.defmock(MockOrderGateway, for: FoodOrderProducao.InterfaceAdapters.Gateways.OrderGatewayBehaviour)

[
  Tesla,
  FoodOrderProducao.Infra.Repo.Mongo,
  FoodOrderProducao.UseCases.InitializeProduction,
  FoodOrderProducao.UseCases.UpdateProductionAndOrderStatus,
  FoodOrderProducao.UseCases.GetProduction,
  FoodOrderProducao.InterfaceAdapters.Controllers.ProductionController,
  FoodOrderProducao.InterfaceAdapters.DTOs.EventProductionDTO,
  FoodOrderProducao.InterfaceAdapters.DTOs.WebProductionDTO
]
|> Enum.each(&Mimic.copy(&1))
