defmodule HaberdashWeb.CheckoutLive.FormComponent do
  use HaberdashWeb, :live_component

  alias Haberdash.Transactions

  @impl true
  def update(%{checkout: checkout} = assigns, socket) do
    changeset = Transactions.change_checkout(checkout)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"checkout" => checkout_params}, socket) do
    changeset =
      socket.assigns.checkout
      |> Transactions.change_checkout(checkout_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"checkout" => checkout_params}, socket) do
    save_checkout(socket, socket.assigns.action, checkout_params)
  end

  defp save_checkout(socket, :edit, checkout_params) do
    case Transactions.update_checkout(socket.assigns.checkout, checkout_params) do
      {:ok, _checkout} ->
        {:noreply,
         socket
         |> put_flash(:info, "Checkout updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_checkout(socket, :new, checkout_params) do
    case Transactions.create_checkout(checkout_params) do
      {:ok, _checkout} ->
        {:noreply,
         socket
         |> put_flash(:info, "Checkout created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
