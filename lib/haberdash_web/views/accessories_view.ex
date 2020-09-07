defmodule HaberdashWeb.AccessoriesView do
  use HaberdashWeb, :view
  alias HaberdashWeb.AccessoriesView

  def render("index.json", %{accessories: accessories}) do
    %{data: render_many(accessories, AccessoriesView, "accessories.json")}
  end

  def render("show.json", %{accessories: accessories}) do
    %{data: render_one(accessories, AccessoriesView, "accessories.json")}
  end

  def render("accessories.json", %{accessories: accessories}) do
    %{id: accessories.id, name: accessories.name, price: accessories.price}
  end
end
