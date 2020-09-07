defmodule HaberdashWeb.OrdersView do
  use HaberdashWeb, :view
  alias HaberdashWeb.OrdersView

  def render("index.json", %{orders: orders}) do
    %{data: render_many(orders, OrdersView, "orders.json")}
  end

  def render("show.json", %{orders: orders}) do
    %{data: render_one(orders, OrdersView, "orders.json")}
  end

  def render("orders.json", %{orders: orders}) do
    %{
      id: orders.id,
      customer_id: orders.customer_id,
      drop_off_location: orders.drop_off_location,
      drop_off_address: orders.drop_off_address,
      franchise_id: orders.franchise_id,
      items: orders.items
    }
  end
end
