defmodule HaberdashWeb.CollectionView do
  use HaberdashWeb, :view
  alias HaberdashWeb.CollectionView

  def render("index.json", %{collection: collection}) do
    %{data: render_many(collection, CollectionView, "collection.json")}
  end

  def render("show.json", %{collection: collection}) do
    %{data: render_one(collection, CollectionView, "collection.json")}
  end

  def render("collection.json", %{collection: collection}) do
    %{id: collection.id,
      name: collection.name,
      description: collection.description}
  end
end
