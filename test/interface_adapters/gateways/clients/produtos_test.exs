defmodule FoodOrderProducao.InterfaceAdapters.Gateways.Clients.ProdutosTest do
  use ExUnit.Case, async: true
  import Mock

  alias FoodOrderProducao.InterfaceAdapters.Gateways.Clients.Produtos

  describe "get_products/1" do
    test "successfully retrieves products with a 2xx response" do
      product_ids = ["prod-1", "prod-2"]
      response_body = Jason.encode!([
        %{"id" => "prod-1", "nome" => "Product 1", "tipo" => "Category 1", "preco" => 10.0, "descricao" => "Description 1", "tempoPreparo" => 15, "imagens" => []},
        %{"id" => "prod-2", "nome" => "Product 2", "tipo" => "Category 2", "preco" => 20.0, "descricao" => "Description 2", "tempoPreparo" => 20, "imagens" => []}
      ])

      with_mock Tesla,
        [
          get: fn _, _, _ -> {:ok, %{status: 200, body: response_body}} end,
          client: fn _ -> [] end
        ] do
        assert {:ok, products} = Produtos.get_products(product_ids)
        assert length(products) == 2
      end
    end

    test "returns error with a non-2xx response" do
      product_ids = ["prod-1", "prod-2"]

      with_mock Tesla,
        [
          get: fn _, _, _ -> {:ok, %{status: 404, body: "Not Found"}} end,
          client: fn _ -> [] end
        ] do
        assert {:error, "Not Found"} = Produtos.get_products(product_ids)
      end
    end

    test "returns error when request fails" do
      product_ids = ["prod-1", "prod-2"]

      with_mock Tesla,
        [
          get: fn _, _, _ -> {:error, "Network Error"} end,
          client: fn _ -> [] end
        ] do
        assert {:error, {:error, "Network Error"}} = Produtos.get_products(product_ids)
      end
    end

    test "returns error when no product ids are provided" do
      assert {:error, "No product ids provided"} = Produtos.get_products([])
    end
  end
end
