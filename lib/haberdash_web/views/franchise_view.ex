defmodule HaberdashWeb.FranchiseView do
  use HaberdashWeb, :view
  alias HaberdashWeb.FranchiseView

  def render("index.json", %{franchise: franchise}) do
    %{data: render_many(franchise, FranchiseView, "franchise.json")}
  end

  def render("show.json", %{franchise: franchise}) do
    %{data: render_one(franchise, FranchiseView, "franchise.json")}
  end

  def render("franchise.json", %{franchise: franchise}) do
    %{
      id: franchise.id,
      name: franchise.name,
      description: franchise.description,
      phone_number: franchise.phone_number
    }
  end
end
