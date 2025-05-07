defmodule FoodOrderProducao.Infra.Web.Endpoints do
  use Plug.Router
  require Logger

  alias FoodOrderProducao.Infra.Web.Controllers.ProductionController

  plug(:match)

  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason)

  plug(:dispatch)

  get "/api/health" do
    send_resp(conn, 200, "Hello... All good!")
  end

  put "/api/production/status" do
    case ProductionController.update_production_status(conn.body_params) do
      {:ok, _} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(%{message: "Production status updated"}))

      {:error, error} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          400,
          Jason.encode!(%{message: "Error updating production status: #{inspect(error)}"})
        )
    end
  end

  get "/api/productions/:order_id" do
    case ProductionController.get_production(conn.params["order_id"]) do
      {:ok, production} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(production))
    end
  end

  match _ do
    send_resp(conn, 404, "Page not found")
  end
end
