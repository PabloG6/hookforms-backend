defmodule HaberdashWeb.CustomerView do
  use HaberdashWeb, :view
  alias HaberdashWeb.CustomerView

  def render("index.json", %{customer: customer}) do
    %{data: render_many(customer, CustomerView, "customer.json")}
  end

  def render("show.json", %{customer: customer}) do
    %{data: render_one(customer, CustomerView, "customer.json")}
  end

  def render("customer.json", %{customer: customer}) do
    %{
      id: customer.id,
      name: customer.name,
      address: customer.address,
      coordinates: customer.coordinates,
      email_address: customer.email_address,
      password: customer.password,
      is_activated: customer.is_activated,
      password_hash: customer.password_hash,
      is_email_confirmed: customer.is_email_confirmed,
      is_phone_number_confirmed: customer.is_phone_number_confirmed
    }
  end
end
