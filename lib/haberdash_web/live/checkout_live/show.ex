defmodule HaberdashWeb.CheckoutLive.Show do
  use HaberdashWeb, :live_view

  alias Haberdash.Transactions

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:checkout, Transactions.get_checkout!(id))}
  end

  defp page_title(:show), do: "Show Checkout"
  defp page_title(:edit), do: "Edit Checkout"
end
