defmodule HaberdashWeb.CustomerControllerTest do
  use HaberdashWeb.ConnCase

  alias Haberdash.Account
  alias Haberdash.Account.Customer

  @create_attrs %{
    address: "some address",
    coordinates: [],
    email_address: "some email_address",
    is_activated: true,
    is_email_confirmed: true,
    is_phone_number_confirmed: true,
    name: "some name",
    password: "some password",
    password_hash: "some password_hash"
  }
  @update_attrs %{
    address: "some updated address",
    coordinates: [],
    email_address: "some updated email_address",
    is_activated: false,
    is_email_confirmed: false,
    is_phone_number_confirmed: false,
    name: "some updated name",
    password: "some updated password",
    password_hash: "some updated password_hash"
  }
  @invalid_attrs %{address: nil, coordinates: nil, email_address: nil, is_activated: nil, is_email_confirmed: nil, is_phone_number_confirmed: nil, name: nil, password: nil, password_hash: nil}

  def fixture(:customer) do
    {:ok, customer} = Account.create_customer(@create_attrs)
    customer
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all customer", %{conn: conn} do
      conn = get(conn, Routes.customer_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create customer" do
    test "renders customer when data is valid", %{conn: conn} do
      conn = post(conn, Routes.customer_path(conn, :create), customer: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.customer_path(conn, :show, id))

      assert %{
               "id" => id,
               "address" => "some address",
               "coordinates" => [],
               "email_address" => "some email_address",
               "is_activated" => true,
               "is_email_confirmed" => true,
               "is_phone_number_confirmed" => true,
               "name" => "some name",
               "password" => "some password",
               "password_hash" => "some password_hash"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.customer_path(conn, :create), customer: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update customer" do
    setup [:create_customer]

    test "renders customer when data is valid", %{conn: conn, customer: %Customer{id: id} = customer} do
      conn = put(conn, Routes.customer_path(conn, :update, customer), customer: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.customer_path(conn, :show, id))

      assert %{
               "id" => id,
               "address" => "some updated address",
               "coordinates" => [],
               "email_address" => "some updated email_address",
               "is_activated" => false,
               "is_email_confirmed" => false,
               "is_phone_number_confirmed" => false,
               "name" => "some updated name",
               "password" => "some updated password",
               "password_hash" => "some updated password_hash"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, customer: customer} do
      conn = put(conn, Routes.customer_path(conn, :update, customer), customer: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete customer" do
    setup [:create_customer]

    test "deletes chosen customer", %{conn: conn, customer: customer} do
      conn = delete(conn, Routes.customer_path(conn, :delete, customer))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.customer_path(conn, :show, customer))
      end
    end
  end

  defp create_customer(_) do
    customer = fixture(:customer)
    %{customer: customer}
  end
end
