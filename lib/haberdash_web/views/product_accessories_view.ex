defmodule HaberdashWeb.ProductAccessoriesView do
  use HaberdashWeb, :view
  alias HaberdashWeb.ProductAccessoriesView

  def render("index.json", %{product_accessories: product_accessories}) do
    %{data: render_many(product_accessories, ProductAccessoriesView, "product_accessories.json")}
  end

  def render("show.json", %{product_accessories: product_accessories}) do
    %{data: render_one(product_accessories, ProductAccessoriesView, "product_accessories.json")}
  end

  def render("product_accessories.json", %{product_accessories: product_accessories}) do
    %{id: product_accessories.id,
      product_id: product_accessories.product_id,
      accessories_id: product_accessories.accessories_id}
  end
end
