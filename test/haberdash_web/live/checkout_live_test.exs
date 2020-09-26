defmodule HaberdashWeb.CheckoutLiveTest do
  use HaberdashWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Haberdash.Transactions

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp fixture(:checkout) do
    {:ok, checkout} = Transactions.create_checkout(@create_attrs)
    checkout
  end

  defp create_checkout(_) do
    checkout = fixture(:checkout)
    %{checkout: checkout}
  end

  describe "Index" do
    setup [:create_checkout]

    test "lists all checkout", %{conn: conn, checkout: checkout} do
      {:ok, _index_live, html} = live(conn, Routes.checkout_index_path(conn, :index))

      assert html =~ "Listing Checkout"
    end

    test "saves new checkout", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.checkout_index_path(conn, :index))

      assert index_live |> element("a", "New Checkout") |> render_click() =~
               "New Checkout"

      assert_patch(index_live, Routes.checkout_index_path(conn, :new))

      assert index_live
             |> form("#checkout-form", checkout: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#checkout-form", checkout: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.checkout_index_path(conn, :index))

      assert html =~ "Checkout created successfully"
    end

    test "updates checkout in listing", %{conn: conn, checkout: checkout} do
      {:ok, index_live, _html} = live(conn, Routes.checkout_index_path(conn, :index))

      assert index_live |> element("#checkout-#{checkout.id} a", "Edit") |> render_click() =~
               "Edit Checkout"

      assert_patch(index_live, Routes.checkout_index_path(conn, :edit, checkout))

      assert index_live
             |> form("#checkout-form", checkout: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#checkout-form", checkout: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.checkout_index_path(conn, :index))

      assert html =~ "Checkout updated successfully"
    end

    test "deletes checkout in listing", %{conn: conn, checkout: checkout} do
      {:ok, index_live, _html} = live(conn, Routes.checkout_index_path(conn, :index))

      assert index_live |> element("#checkout-#{checkout.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#checkout-#{checkout.id}")
    end
  end

  describe "Show" do
    setup [:create_checkout]

    test "displays checkout", %{conn: conn, checkout: checkout} do
      {:ok, _show_live, html} = live(conn, Routes.checkout_show_path(conn, :show, checkout))

      assert html =~ "Show Checkout"
    end

    test "updates checkout within modal", %{conn: conn, checkout: checkout} do
      {:ok, show_live, _html} = live(conn, Routes.checkout_show_path(conn, :show, checkout))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Checkout"

      assert_patch(show_live, Routes.checkout_show_path(conn, :edit, checkout))

      assert show_live
             |> form("#checkout-form", checkout: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#checkout-form", checkout: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.checkout_show_path(conn, :show, checkout))

      assert html =~ "Checkout updated successfully"
    end
  end
end
