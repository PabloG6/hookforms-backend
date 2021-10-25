defmodule FormsWeb.FormController do
  use FormsWeb, :controller

  alias Forms.Folder
  alias Forms.Folder.Form
  alias Forms.Accounts
  alias Forms.Guardian

  action_fallback FormsWeb.FallbackController

  def index(conn, _params) do
    with %Accounts.Owner{id: owner_id} <- Guardian.Plug.current_resource(conn) do


    end

    form = Folder.list_form()
    render(conn, "index.json", form: form)
  end

  def create(conn, form_params) do
    IO.puts "inside form params"
    with %Accounts.Owner{id: owner_id} <- Guardian.Plug.current_resource(conn),
    {:ok, %Form{} = form} <- Folder.create_form(form_params |> Enum.into(%{"owner_id" => owner_id})) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.form_path(conn, :show, form))
      |> render("show.json", form: form)
    else
      error ->
        IO.inspect error
        error
    end
  end

  def show(conn, %{"id" => id}) do
    form = Folder.get_form!(id)
    render(conn, "show.json", form: form)
  end

  def update(conn, %{"id" => id, "form" => form_params}) do
    form = Folder.get_form!(id)

    with {:ok, %Form{} = form} <- Folder.update_form(form, form_params) do
      render(conn, "show.json", form: form)
    end
  end

  def delete(conn, %{"id" => id}) do
    form = Folder.get_form!(id)

    with {:ok, %Form{}} <- Folder.delete_form(form) do
      send_resp(conn, :no_content, "")
    end
  end
end
