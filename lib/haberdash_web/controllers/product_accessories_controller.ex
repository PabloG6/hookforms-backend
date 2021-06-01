defmodule HaberdashWeb.ProductAssocController do
  use HaberdashWeb, :controller

  alias Haberdash.{Assoc, Inventory}
  alias Haberdash.Assoc.ProductAssoc

  action_fallback HaberdashWeb.FallbackController

  def create(conn, %{"product_id" => product_id, "accessories_id" => accessories_id}) do
    _product = Inventory.get_products!(product_id)
    _accessory = Inventory.get_products!(accessories_id)

    with {:ok, %ProductAssoc{} = product_accessories} <-
           Assoc.create_product_assoc(%{
             product_id: product_id,
             accessories_id: accessories_id
           }) do
      conn
      |> put_status(:created)
      |> render("show.json", product_accessories: product_accessories)
    end
  end

  def show(conn, %{"product_id" => product_id, "accessories_id" => accessories_id}) do
    with {:ok, product_accessories} <-
           Assoc.get_product_assoc_by(%{
             accessories_id: accessories_id,
             product_id: product_id
           }) do
      conn
      |> put_status(:ok)
      |> render("show.json", product_accessories: product_accessories)
    else
      {:error, :not_found} ->
        send_resp(
          conn,
          :not_found,
          Poison.encode!(%{
            message: "No accessory or product exist within the association",
            code: :not_found
          })
        )
    end
  end

  def delete(conn, %{"product_id" => product_id, "accessories_id" => accessories_id}) do
    with {:ok, product_accessories} =
           Assoc.get_product_assoc_by(
             product_id: product_id,
             accessories_id: accessories_id
           ),
         {:ok, %ProductAssoc{}} <- Assoc.delete_product_assoc(product_accessories) do
      send_resp(conn, :no_content, "")
    else
      {:error, :not_found} ->
        send_resp(
          conn,
          :not_found,
          Poison.encode!(%{
            message: "No accessory or product exist within this association.",
            code: :not_found
          })
        )
    end
  end
end
