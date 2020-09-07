defmodule HaberdashWeb.AccessoriesControllerTest do
  use HaberdashWeb.ConnCase

  alias Haberdash.{Inventory, Account, Business, Groups, Auth}
  alias Haberdash.Inventory.Accessories

  @create_attrs %{
    price: 42,
    name: "Coleslaw",
    description: "A side of coleslaw"
  }

  @owner_attrs %{
    name: "Colonel Sanders",
    email: "thecolonel@kfc.com",
    password: "ilovekentuckyfriedchicken",
    phone_number: "+1234567890"
  }

  @franchise_attrs %{
    description: "Finger Licking Good",
    name: "Kentucky Fried Chicken",
    phone_number: "+13573829874"
  }

  @product_attrs %{
    name: "Big Deal",
    description:
      "Three pieces of fried chicken, with a side of fries and medium soda of your choice",
    price: 120.5
  }

  @collection_attrs %{
    description: "some description",
    name: "some name"
  }
  @update_attrs %{
    franchise: "7488a646-e31f-11e4-aace-600308960668",
    price: 43,
    title: "some updated title"
  }
  @invalid_attrs %{franchise: nil, price: nil, title: nil}

  def fixture(attrs \\ %{}) do
    {:ok, accessories} = Inventory.create_accessories(attrs |> Enum.into(@create_attrs))
    accessories
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:init]

    test "lists all accessories", %{conn: conn} do
      conn = get(conn, Routes.accessories_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create accessories" do
    setup [:init]

    test "renders accessories when data is valid", %{conn: conn} do
      conn = post(conn, Routes.accessories_path(conn, :create), accessories: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.accessories_path(conn, :show, id))

      assert %{
               "id" => id,
               "price" => "42",
               "name" => "Coleslaw"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.accessories_path(conn, :create), accessories: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update accessories" do
    setup [:init, :create_accessories]

    test "renders accessories when data is valid", %{
      conn: conn,
      accessories: %Accessories{id: id} = accessories
    } do
      conn =
        put(conn, Routes.accessories_path(conn, :update, accessories), accessories: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.accessories_path(conn, :show, id))

      assert %{
               "id" => id,
               "price" => "43",
               "name" => "Coleslaw"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, accessories: accessories} do
      conn =
        put(conn, Routes.accessories_path(conn, :update, accessories), accessories: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete accessories" do
    setup [:init, :create_accessories]

    test "deletes chosen accessories", %{conn: conn, accessories: accessories} do
      conn = delete(conn, Routes.accessories_path(conn, :delete, accessories))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.accessories_path(conn, :show, accessories))
      end
    end
  end

  defp init(%{conn: conn}) do
    {:ok, owner} = Account.create_owner(@owner_attrs)

    {:ok, franchise} =
      Business.create_franchise(@franchise_attrs |> Enum.into(%{owner_id: owner.id}))

    {:ok, product} =
      Inventory.create_products(@product_attrs |> Enum.into(%{franchise_id: franchise.id}))

    {:ok, collection} =
      Groups.create_collection(@collection_attrs |> Enum.into(%{franchise_id: franchise.id}))

    {:ok, token, _claims} = Auth.Guardian.encode_and_sign(owner)

    conn =
      conn
      |> put_req_header("authorization", "Bearer " <> token)
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn, owner: owner, product: product, franchise: franchise}
  end

  defp create_accessories(%{product: product, franchise: franchise}) do
    accessories = fixture(%{franchise_id: franchise.id})
    %{accessories: accessories}
  end
end
