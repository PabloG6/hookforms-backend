defmodule HaberdashWeb.DeveloperView do
  use HaberdashWeb, :view
  alias HaberdashWeb.DeveloperView
  require Logger

  def render("index.json", %{developer: developer}) do
    %{data: render_many(developer, DeveloperView, "developers.json")}
  end

  def render("show.json", %{developers: developers}) do
    Logger.info("render developer as json")
    %{data: render_one(developers, DeveloperView, "developers.json")}
  end

  def render("developers.json", %{developer: developers}) do
    %{
      id: developers.id,
      name: developers.name,
      email: developers.email,
      api_key: developers.api_key
    }
  end
end
