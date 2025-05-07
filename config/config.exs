import Config

config :food_order_producao, :api,
  port: System.get_env("FOOD_ORDER_PRODUCAO_ENDPOINT_PORT", "4002") |> String.to_integer()

config :tesla, :adapter, Tesla.Adapter.Mint

import_config "#{config_env()}.exs"
