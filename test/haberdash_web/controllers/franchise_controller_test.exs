defmodule HaberdashWeb.FranchiseControllerTest do
  use HaberdashWeb.ConnCase

  alias Haberdash.Business
  alias Haberdash.Business.Franchise

  @create_attrs %{
    description: "some description",
    name: "some name",
    phone_number: "some phone_number"
  }
  @update_attrs %{
    description: "some updated description",
    name: "some updated name",
    phone_number: "some updated phone_number"
  }
  @invalid_attrs %{description: nil, name: nil, phone_number: nil}

  def fixture(:franchise) do
    {:ok, franchise} = Business.create_franchise(@create_attrs)
    franchise
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all franchise", %{conn: conn} do
      conn = get(conn, Routes.franchise_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create franchise" do
    test "renders franchise when data is valid", %{conn: conn} do
      conn = post(conn, Routes.franchise_path(conn, :create), franchise: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.franchise_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "name" => "some name",
               "phone_number" => "some phone_number"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.franchise_path(conn, :create), franchise: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update franchise" do
    setup [:create_franchise]

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
               "phone_number" => "some updated phone_number"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, franchise: franchise} do
      conn = put(conn, Routes.franchise_path(conn, :update, franchise), franchise: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete franchise" do
    setup [:create_franchise]

    test "deletes chosen franchise", %{conn: conn, franchise: franchise} do
      conn = delete(conn, Routes.franchise_path(conn, :delete, franchise))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.franchise_path(conn, :show, franchise))
      end
    end
  end

  defp create_franchise(_) do
    franchise = fixture(:franchise)
    %{franchise: franchise}
  end
end
