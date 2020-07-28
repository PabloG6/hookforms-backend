defmodule HaberdashWeb.OwnerControllerTest do
  use HaberdashWeb.ConnCase
  alias Haberdash.{Auth}
  alias Haberdash.Account
  alias Haberdash.Account.Owner
  require Logger

  @create_attrs %{
    email: "some email",
    name: "some name",
    phone_number: "some phone_number",
    password: "password"
  }
  @update_attrs %{
    email: "some updated email",
    name: "some updated name",
    phone_number: "some updated phone_number",
    password: "password"
  }
  @invalid_attrs %{email: nil, name: nil, phone_number: nil}

  def fixture(:owner) do
    {:ok, owner} = Account.create_owner(@create_attrs)
    owner
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_owner, :authenticate_owner]

    test "lists all owners", %{conn: conn, owner: owner} do
      conn = get(conn, Routes.owner_path(conn, :index))

      assert json_response(conn, 200)["data"] == [
               %{
                 "id" => owner.id,
                 "phone_number" => owner.phone_number,
                 "email" => owner.email,
                 "name" => owner.name
               }
             ]
    end
  end

  describe "create owner" do
    test "renders owner when data is valid", %{conn: conn} do
      conn = post(conn, Routes.owner_path(conn, :create), owner: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
      owner = Account.get_owner!(id)

      {:ok, token, _claims} = Haberdash.Auth.Guardian.encode_and_sign(owner)
      conn = put_req_header(recycle(conn), "authorization", "Bearer " <> token)
      conn = get(conn, Routes.owner_path(conn , :show, id))

      assert %{
               "id" => id,
               "email" => "some email",
               "name" => "some name",
               "phone_number" => "some phone_number"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.owner_path(conn, :create), owner: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update owner" do
    setup [:create_owner, :authenticate_owner]

    test "renders owner when data is valid", %{conn: conn, owner: %Owner{id: id} = owner} do
      Logger.info("current token: #{Guardian.Plug.current_token(conn)}")
      conn = put(conn, Routes.owner_path(conn, :update, owner), owner: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.owner_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => "some updated email",
               "name" => "some updated name",
               "phone_number" => "some updated phone_number"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, owner: owner} do
      conn = put(conn, Routes.owner_path(conn, :update, owner), owner: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete owner" do
    setup [:create_owner, :authenticate_owner]

    test "deletes chosen owner", %{conn: conn, owner: owner} do
      conn = delete(conn, Routes.owner_path(conn, :delete, owner))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.owner_path(conn, :show, owner))
      end
    end
  end

  defp create_owner(_) do
    owner = fixture(:owner)
    %{owner: owner}
  end

  def authenticate_owner(%{conn: conn, owner: owner}) do
    Logger.debug("debugging claims")
    {:ok, token, _claims} = Auth.Guardian.encode_and_sign(owner)

    conn =
      conn
      |> put_req_header("authorization", "Bearer " <> token)
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn, owner: owner}
  end
end
