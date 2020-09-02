defmodule HaberdashWeb.ProductAccessoriesControllerTest do
  use HaberdashWeb.ConnCase

  alias Haberdash.{Assoc, Account, Inventory, Business, Auth}
  alias Haberdash.Inventory.{Accessories, Products}
  alias Haberdash.Assoc.ProductAccessories



  @owner_attrs %{
    email: "some@email.com",
    name: "some name",
    phone_number: "+4915843854",
    password: "some password"
  }

  @accessory_attrs %{
    name: "Strawberry Milkshake",
    description: "A mixed slushy of strawberries and milk",
    price: 19.99
  }


  @franchise_attrs %{
    description: "some description",
    name: "some name",
    phone_number: "+4588913544"
  }

  @product_attrs %{
    description: "some description",
    name: "some name",
    price: 120.5,
  }
  @invalid_attrs %{accessories_id: nil, product_id: nil}

  def fixture(attrs \\ %{}) do
    {:ok, product_accessories} = Assoc.create_product_accessories(attrs)
    product_accessories
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end



  describe "create product_accessories" do
    setup [:init]
    test "renders product_accessories when data is valid", %{conn: conn, product: %Products{id: product_id} = product, accessories: %Accessories{id: accessories_id} = accessories} do
      conn = post(conn, Routes.product_accessories_path(conn, :create, product.id, accessories.id), product_accessories: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.product_accessories_path(conn, :show, product.id, accessories.id))

      assert %{
               "id" => id,
               "accessories_id" => accessories_id,
               "product_id" => product_id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, product: product, accessories: accessories} do
      assert_error_sent 404, fn ->
        post(conn, Routes.product_accessories_path(conn, :create, "25c0b427-84cf-43fa-905b-d1bcf4c577d9", "8c550503-c008-4794-b6b0-30e98de86c09"))
      end
    end
  end


  describe "delete product_accessories" do
    setup [:init, :create_product_accessories]

    test "deletes chosen product_accessories", %{conn: conn, product_accessories: product_accessories} do
      conn = delete(conn, Routes.product_accessories_path(conn, :delete, product_accessories.product_id), accessories_id: product_accessories.accessories_id)
      assert response(conn, 204)

      conn = get(conn, Routes.product_accessories_path(conn, :show, product_accessories.product_id, product_accessories.accessories_id))
      assert response(conn, 404)
    end
  end

  defp init(%{conn: conn}) do
    {:ok, owner} = Account.create_owner(@owner_attrs)
    {:ok, franchise} = Business.create_franchise(@franchise_attrs |> Enum.into(%{owner_id: owner.id}))
    {:ok, product} = Inventory.create_products(@product_attrs |> Enum.into(%{franchise_id: franchise.id}))
    {:ok, accessories} = Inventory.create_accessories(@accessory_attrs |> Enum.into(%{franchise_id: franchise.id}))
    {:ok, token, _} = Auth.Guardian.encode_and_sign(owner)
    conn = conn |> put_req_header("authorization", "Bearer " <> token)
    %{conn: conn, product: product, accessories: accessories}
  end
  defp create_product_accessories(%{product: product, accessories: accessory, conn: conn}) do
    product_accessories = fixture(%{product_id: product.id, accessories_id: accessory.id})
    %{product_accessories: product_accessories, conn: conn}
  end
end
