defmodule HaberdashWeb.ProductsControllerTest do
  use HaberdashWeb.ConnCase

  alias Haberdash.{Inventory, Auth, Account, Business}
  alias Haberdash.Inventory.Products

  @create_attrs %{
    description: "some description",
    name: "some name",
    price: "120.5",
    price_id: "some price_id"
  }
  @update_attrs %{
    description: "some updated description",
    name: "some updated name",
    price: "456.7",
    price_id: "some updated price_id"
  }

  @owner_attrs %{
    email: "some@email.com",
    name: "some name",
    phone_number: "+4915843854",
    password: "some password"
  }

  @franchise_attrs %{
    description: "some description",
    name: "some name",
    phone_number: "+4588913544"
  }

  @invalid_attrs %{description: nil, name: nil, price: nil, price_id: nil}

  def fixture(attrs \\ %{}) do
    {:ok, products} =  attrs |> Enum.into(@create_attrs) |> Inventory.create_products()
    products
  end

  setup %{conn: conn} do
    {:ok, owner} = Account.create_owner(@owner_attrs)

    {:ok, franchise} =
      Business.create_franchise(@franchise_attrs |> Enum.into(%{owner_id: owner.id}))

    {:ok, token, _claims} = Auth.Guardian.encode_and_sign(owner)

    {:ok,
     conn:
       put_req_header(conn, "accept", "application/json")
       |> put_req_header("authorization", "Bearer " <> token),
      franchise: franchise
      }

  end

  describe "index" do
    test "lists all product", %{conn: conn} do
      conn = get(conn, Routes.products_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create products" do
    test "renders products when data is valid", %{conn: conn} do
      conn = post(conn, Routes.products_path(conn, :create), products: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.products_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "name" => "some name",
               "price" => "120.5",
               "price_id" => "some price_id"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.products_path(conn, :create), products: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update products" do
    setup [:create_products]

    test "renders products when data is valid", %{
      conn: conn,
      products: %Products{id: id} = products
    } do
      conn = put(conn, Routes.products_path(conn, :update, products), products: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.products_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some updated description",
               "name" => "some updated name",
               "price" => "456.7",
               "price_id" => "some updated price_id"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, products: products} do
      conn = put(conn, Routes.products_path(conn, :update, products), products: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete products" do
    setup [:create_products]

    test "deletes chosen products", %{conn: conn, products: products} do
      conn = delete(conn, Routes.products_path(conn, :delete, products))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.products_path(conn, :show, products))
      end
    end
  end

  defp create_products(%{franchise: franchise}) do
    products = fixture(%{franchise_id: franchise.id})
    %{products: products}
  end
end
