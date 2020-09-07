defmodule HaberdashWeb.CollectionControllerTest do
  use HaberdashWeb.ConnCase

  alias Haberdash.{Groups, Account, Business}
  alias Haberdash.Groups.Collection

  @create_attrs %{
    description: "some description",
    name: "some name"
  }
  @update_attrs %{
    description: "some updated description",
    name: "some updated name"
  }
  @invalid_attrs %{description: nil, name: nil}

  @franchise_attrs %{
    description: "some description",
    name: "some name",
    phone_number: "+4588913544"
  }

  @owner_attrs %{
    email: "random@email.com",
    name: "some name",
    phone_number: "+458891458",
    password: "some password"
  }
  def fixture(attrs \\ %{}) do
    {:ok, collection} = attrs |> Enum.into(@create_attrs) |> Groups.create_collection()
    collection
  end

  setup %{conn: conn} do
    {:ok, owner} = Account.create_owner(@owner_attrs)

    {:ok, franchise} =
      Business.create_franchise(%{owner_id: owner.id} |> Enum.into(@franchise_attrs))

    {:ok, token, _} = Haberdash.Auth.Guardian.encode_and_sign(owner)

    {:ok,
     conn:
       put_req_header(conn, "accept", "application/json")
       |> put_req_header("authorization", "Bearer " <> token),
     franchise: franchise}
  end

  describe "index" do
    test "lists all collection", %{conn: conn} do
      conn = get(conn, Routes.collection_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create collection" do
    test "renders collection when data is valid", %{conn: conn} do
      conn = post(conn, Routes.collection_path(conn, :create), collection: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.collection_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.collection_path(conn, :create), collection: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update collection" do
    setup [:create_collection]

    test "renders collection when data is valid", %{
      conn: conn,
      collection: %Collection{id: id} = collection
    } do
      conn =
        put(conn, Routes.collection_path(conn, :update, collection), collection: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.collection_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some updated description",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, collection: collection} do
      conn =
        put(conn, Routes.collection_path(conn, :update, collection), collection: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete collection" do
    setup [:create_collection]

    test "deletes chosen collection", %{conn: conn, collection: collection} do
      conn = delete(conn, Routes.collection_path(conn, :delete, collection))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.collection_path(conn, :show, collection))
      end
    end
  end

  defp create_collection(%{franchise: franchise}) do
    collection = fixture(%{franchise_id: franchise.id})
    %{collection: collection}
  end
end
