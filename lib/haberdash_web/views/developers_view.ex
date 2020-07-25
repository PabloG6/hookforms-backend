defmodule HaberdashWeb.DevelopersView do
  use HaberdashWeb, :view
  alias HaberdashWeb.DevelopersView

  def render("index.json", %{developer: developer}) do
    %{data: render_many(developer, DevelopersView, "developers.json")}
  end

  def render("show.json", %{developers: developers}) do
    %{data: render_one(developers, DevelopersView, "developers.json")}
  end

  def render("developers.json", %{developers: developers}) do
    %{id: developers.id,
      name: developers.name,
      email: developers.email,
      password_hash: developers.password_hash,
      api_key: developers.api_key}
  end
end
