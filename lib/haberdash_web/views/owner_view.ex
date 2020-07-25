defmodule HaberdashWeb.OwnerView do
  use HaberdashWeb, :view
  alias HaberdashWeb.OwnerView

  def render("index.json", %{owner: owner}) do
    %{data: render_many(owner, OwnerView, "owner.json")}
  end

  def render("show.json", %{owner: owner}) do
    %{data: render_one(owner, OwnerView, "owner.json")}
  end

  def render("owner.json", %{owner: owner}) do
    %{id: owner.id,
      name: owner.name,
      email: owner.email,
      phone_number: owner.phone_number}
  end
end
