defmodule HaberdashWeb.ProductGroupsView do
  use HaberdashWeb, :view
  alias HaberdashWeb.ProductGroupsView

  def render("index.json", %{product_groups: product_groups}) do
    %{data: render_many(product_groups, ProductGroupsView, "product_groups.json")}
  end

  def render("show.json", %{product_groups: product_groups}) do
    %{data: render_one(product_groups, ProductGroupsView, "product_groups.json")}
  end

  def render("product_groups.json", %{product_groups: product_groups}) do
    IO.write("product_groups ")
    IO.inspect(product_groups)
    %{id: product_groups.id}
  end

  def render("group_info_list.json", %{product_groups: product_groups}) do
    %{data: render_many(product_groups, ProductGroupsView, "product_info.json")}
  end

  def render("group_info.json", %{product_groups: product_group}) do
    %{
      id: product_group.id,
      collection: %{
        id: product_group.collection.id,
        name: product_group.collection.name,
        description: product_group.collection.description
      },
      product: %{
        id: product_group.product.id,
        name: product_group.product.name,
        description: product_group.product.description
      }
    }
  end
end
