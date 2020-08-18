defmodule HaberdashWeb.ProductGroupsControllerTest do
  use HaberdashWeb.ConnCase

  alias Haberdash.Assoc
  alias Haberdash.Assoc.ProductGroups
  alias Haberdash.{Assoc, Account, Business, Inventory, Groups, Auth}



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


  @product_attrs %{
    description: "some description",
    name: "some name",
    price: "120.5",
    price_id: "some price_id"
  }
  @group_attrs %{description: "some description", name: "some name"}

  def fixture(attrs \\ %{}) do
    {:ok, product_groups} = Assoc.create_product_groups(attrs)
    product_groups
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all product_groups", %{conn: conn} do
      conn = get(conn, Routes.product_groups_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create product_groups" do
    setup [:prepare]
    test "renders product_groups when data is valid", %{conn: conn, collection: collection, product: product} do
      conn = post(conn, Routes.product_groups_path(conn, :create), product_groups: %{id: product.id, collection_id: collection.id})

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.product_groups_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.product_groups_path(conn, :create), product_groups: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update product_groups" do
    setup [:prepare, :create_product_groups]

    test "renders product_groups when data is valid", %{conn: conn, product_groups: %ProductGroups{id: id} = product_groups} do
      conn = put(conn, Routes.product_groups_path(conn, :update, product_groups), product_groups: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.product_groups_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, product_groups: product_groups} do
      conn = put(conn, Routes.product_groups_path(conn, :update, product_groups), product_groups: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete product_groups" do
    setup [:prepare, :create_product_groups]

    test "deletes chosen product_groups", %{conn: conn, product_groups: product_groups} do
      conn = delete(conn, Routes.product_groups_path(conn, :delete, product_groups.product_id.
      ), collection_id: product_groups.collection_id)
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.product_groups_path(conn, :show, product_groups))
      end
    end
  end

  defp create_product_groups(%{product: product, collection: collection}) do
    product_groups = fixture(%{product_id: product.id, collection_id: collection.id})
    %{product_groups: product_groups}
  end

  defp prepare(%{conn: conn}) do
    {:ok, owner} = Account.create_owner(@owner_attrs)
    {:ok, franchise} = Business.create_franchise(@franchise_attrs |> Enum.into(%{owner_id: owner.id}))
    {:ok, product} = Inventory.create_products(@product_attrs |> Enum.into(%{franchise_id: franchise.id}))
    {:ok, collection} = Groups.create_collection(@group_attrs |> Enum.into(%{franchise_id: franchise.id}))
    {:ok, token, _claims} = Auth.Guardian.encode_and_sign(owner)

    conn =
      conn
      |> put_req_header("authorization", "Bearer " <> token)
      |> put_req_header("accept", "application/json")
    {:ok, product: product, collection: collection, conn: conn}
  end
end
