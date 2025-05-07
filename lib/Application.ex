defmodule FoodOrderProducao.Application do
  use Application
  require Logger

  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: FoodOrderProducao.Supervisor]

    Logger.info("The server has started at port #{port()}...")

    Supervisor.start_link(children(Mix.env()), opts)
  end

  defp children(:test), do: []
  defp children(_), do: [
    {Plug.Cowboy, scheme: :http, plug: FoodOrderProducao.Infra.Web.Endpoints, options: [port: port()]},
    {FoodOrderProducao.Infra.Consumers.Broadway, [queue_name: :production]}
  ]

  defp port, do: Application.get_env(:food_order_producao, :api) |> Keyword.get(:port)
end
