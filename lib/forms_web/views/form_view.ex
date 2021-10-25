defmodule FormsWeb.FormView do
  use FormsWeb, :view
  alias FormsWeb.FormView

  def render("index.json", %{form: form}) do
    %{data: render_many(form, FormView, "form.json")}
  end

  def render("show.json", %{form: form}) do
    %{data: render_one(form, FormView, "form.json")}
  end

  def render("form.json", %{form: form}) do
    %{id: form.id,
      title: form.title,
      description: form.description,
      updated_at: form.updated_at,
      questions: form.questions}
  end
end
