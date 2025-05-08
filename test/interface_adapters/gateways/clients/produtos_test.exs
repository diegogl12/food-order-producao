defmodule FoodOrderProducao.InterfaceAdapters.Gateways.Clients.ProdutosTest do
  use ExUnit.Case, async: false
  use Mimic

  alias FoodOrderProducao.InterfaceAdapters.Gateways.Clients.Produtos

  # Garante que as expectativas sejam verificadas no fim do teste
  setup :set_mimic_global
  setup :verify_on_exit!

  describe "get_products/1" do
    test "successfully retrieves products with a 2xx response" do
      product_ids = ["prod-1", "prod-2"]
      response_body = Jason.encode!([
        %{"id" => "prod-1", "nome" => "Product 1", "tipo" => "Category 1", "preco" => 10.0, "descricao" => "Description 1", "tempoPreparo" => 15, "imagens" => []},
        %{"id" => "prod-2", "nome" => "Product 2", "tipo" => "Category 2", "preco" => 20.0, "descricao" => "Description 2", "tempoPreparo" => 20, "imagens" => []}
      ])

      Tesla
      |> stub(:get, fn _, _, _ -> {:ok, %{status: 200, body: response_body}} end)
      |> stub(:client, fn _ -> [] end)

      assert {:ok, products} = Produtos.get_products(product_ids)
      assert length(products) == 2
    end

    test "returns error with a non-2xx response" do
      product_ids = ["prod-1", "prod-2"]

      Tesla
      |> stub(:get, fn _, _, _ -> {:ok, %{status: 404, body: "Not Found"}} end)
      |> stub(:client, fn _ -> [] end)

      assert {:error, "Not Found"} = Produtos.get_products(product_ids)
    end

    test "returns error when request fails" do
      product_ids = ["prod-1", "prod-2"]

      Tesla
      |> stub(:get, fn _, _, _ -> {:error, "Network Error"} end)
      |> stub(:client, fn _ -> [] end)

      assert {:error, {:error, "Network Error"}} = Produtos.get_products(product_ids)
    end

    test "returns error when no product ids are provided" do
      assert {:error, "No product ids provided"} = Produtos.get_products([])
    end
  end
end
