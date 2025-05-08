defmodule FoodOrderProducao.Infra.Repo.Mongo do
  use Mongo.Repo,
    otp_app: :food_order_producao,
    topology: :mongo
end
