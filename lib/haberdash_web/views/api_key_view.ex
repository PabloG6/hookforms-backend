defmodule HaberdashWeb.ApiKeyView do
  use HaberdashWeb, :view
  alias HaberdashWeb.ApiKeyView

  def render("index.json", %{api_key: api_key}) do
    %{data: render_many(api_key, ApiKeyView, "api_key.json")}
  end

  def render("show.json", %{api_key: api_key}) do
    %{data: render_one(api_key, ApiKeyView, "api_key.json")}
  end

  def render("api_key.json", %{api_key: api_key}) do
    %{id: api_key.id,
      api_key: api_key.api_key,
      developer_id: api_key.developer_id}
  end
end
