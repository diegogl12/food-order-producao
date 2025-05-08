import Config

config :food_order_producao, :api,
  port: System.get_env("FOOD_ORDER_PRODUCAO_ENDPOINT_PORT", "4002") |> String.to_integer()

config :tesla, :adapter, Tesla.Adapter.Mint

config :food_order_producao, FoodOrderProducao.Infra.Repo.Mongo,
  url: "mongodb://#{System.get_env("FOOD_ORDER_MONGO_USERNAME")}:#{System.get_env("FOOD_ORDER_MONGO_PASSWORD")}@#{System.get_env("FOOD_ORDER_MONGO_HOST")}:#{System.get_env("FOOD_ORDER_MONGO_PORT")}/food_order?authSource=admin",
  timeout: 60_000,
  idle_interval: 10_000,
  queue_target: 5_000

import_config "#{config_env()}.exs"
