defmodule Haberdash.MessageView do
  use HaberdashWeb, :view
  def render("messages.json", messages) do
    messages
  end
end
