defmodule HaberdashWeb.FranchiseControllerTest do
  use HaberdashWeb.ConnCase

  alias Haberdash.Business
  alias Haberdash.Business.Franchise
  alias Haberdash.{Account, Auth}
  @create_attrs %{
    description: "some description",
    name: "some name",
    phone_number: "+13573829874"
  }

  @owner_attrs %{
    email: "some@email.com",
    name: "some name",
    phone_number: "+4915843854",
    password: "some password"
  }


  @update_attrs %{
    description: "some updated description",
    name: "some updated name",
    phone_number: "+4915843459"
  }
  @invalid_attrs %{description: nil, name: nil, phone_number: nil}

  def fixture(attrs \\ %{}) do
    {:ok, franchise} = attrs |> Enum.into(@create_attrs) |> Business.create_franchise()
    franchise
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:authenticate_owner]
    test "lists all franchise", %{conn: conn} do
      conn = get(conn, Routes.franchise_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create franchise" do
    setup [:authenticate_owner]
    test "renders franchise when data is valid", %{conn: conn} do
      conn = post(conn, Routes.franchise_path(conn, :create), franchise: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.franchise_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "name" => "some name",
               "phone_number" => "+13573829874"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.franchise_path(conn, :create), franchise: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update franchise" do
    setup [:authenticate_owner, :create_franchise]

    test "renders franchise when data is valid", %{
      conn: conn,
      franchise: %Franchise{id: id} = franchise
    } do
      conn = put(conn, Routes.franchise_path(conn, :update, franchise), franchise: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.franchise_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some updated description",
               "name" => "some updated name",
               "phone_number" => "+4915843459"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, franchise: franchise} do
      conn = put(conn, Routes.franchise_path(conn, :update, franchise), franchise: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete franchise" do
    setup [:authenticate_owner, :create_franchise]

    test "deletes chosen franchise", %{conn: conn, franchise: franchise} do
      conn = delete(conn, Routes.franchise_path(conn, :delete, franchise))
      assert response(conn, 204)
      conn = get(conn, Routes.franchise_path(conn, :show, franchise))

      assert conn.status == 404
    end
  end

  defp create_franchise(%{owner: owner}) do
    franchise = fixture(%{owner_id: owner.id})
    %{franchise: franchise}
  end



  defp authenticate_owner(%{conn: conn}) do
    {:ok, owner} = Account.create_owner(@owner_attrs)
    {:ok, token, _claim} = Auth.Guardian.encode_and_sign(owner)
    conn = put_req_header(conn, "authorization", "Bearer " <> token)
    {:ok, conn: conn, owner: owner}
  end
end
