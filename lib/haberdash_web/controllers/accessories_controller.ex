defmodule HaberdashWeb.AccessoriesController do
  use HaberdashWeb, :controller

  alias Haberdash.Inventory
  alias Haberdash.Inventory.Accessories

  action_fallback HaberdashWeb.FallbackController

  def index(conn, _params) do
    accessories = Inventory.list_accessories()
    render(conn, "index.json", accessories: accessories)
  end

  def create(conn, %{"accessories" => accessories_params}) do
    franchise = conn.private[:franchise]

    with {:ok, %Accessories{} = accessories} <-
           Inventory.create_accessories(
             accessories_params
             |> Enum.into(%{"franchise_id" => franchise.id})
           ) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.accessories_path(conn, :show, accessories))
      |> render("show.json", accessories: accessories)
    end
  end

  def show(conn, %{"id" => id}) do
    accessories = Inventory.get_accessories!(id)
    render(conn, "show.json", accessories: accessories)
  end

  def update(conn, %{"id" => id, "accessories" => accessories_params}) do
    accessories = Inventory.get_accessories!(id)

    with {:ok, %Accessories{} = accessories} <-
           Inventory.update_accessories(accessories, accessories_params) do
      render(conn, "show.json", accessories: accessories)
    end
  end

  def delete(conn, %{"id" => id}) do
    accessories = Inventory.get_accessories!(id)

    with {:ok, %Accessories{}} <- Inventory.delete_accessories(accessories) do
      send_resp(conn, :no_content, "")
    end
  end
end
