defmodule HaberdashWeb.CheckoutLive.Index do
  use HaberdashWeb, :live_view

  alias Haberdash.Transactions
  alias Haberdash.Transactions.Checkout

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :checkout_collection, list_checkout())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Checkout")
    |> assign(:checkout, Transactions.get_checkout!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Checkout")
    |> assign(:checkout, %Checkout{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Checkout")
    |> assign(:checkout, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    checkout = Transactions.get_checkout!(id)
    {:ok, _} = Transactions.delete_checkout(checkout)

    {:noreply, assign(socket, :checkout_collection, list_checkout())}
  end

  defp list_checkout do
    Transactions.list_checkout()
  end
end
