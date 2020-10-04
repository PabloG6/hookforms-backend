defmodule HaberdashWeb.CheckoutLive.Index do
  use HaberdashWeb, :live_view
  require Logger
  alias Haberdash.Transactions
  alias Haberdash.Transactions.Checkout
  alias HaberdashWeb.CheckoutLive.FormComponent

  @impl true
  def mount(_params, session, socket) do
    Logger.info("inside a mount")
    Logger.info("current session: #{inspect(session)}")
    {:ok, assign(socket, :checkout_collection, list_checkout(session["orders"]))}
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


  defp list_checkout(%{"items" => items}) do

    Enum.map(items, fn opts -> struct(Haberdash.Transactions.OrderItems, Poison.Parser.parse!(Poison.encode!(opts), %{keys: :atoms!})) end)
  end

  defp list_checkout do
    Transactions.list_checkout
  end


end
