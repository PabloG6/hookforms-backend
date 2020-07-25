defmodule HaberdashWeb.ProductsView do
  use HaberdashWeb, :view
  alias HaberdashWeb.ProductsView

  def render("index.json", %{product: product}) do
    %{data: render_many(product, ProductsView, "products.json")}
  end

  def render("show.json", %{products: products}) do
    %{data: render_one(products, ProductsView, "products.json")}
  end

  def render("products.json", %{products: products}) do
    %{id: products.id,
      name: products.name,
      price: products.price,
      description: products.description,
      price_id: products.price_id}
  end
end
