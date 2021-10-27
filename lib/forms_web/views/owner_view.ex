defmodule FormsWeb.OwnerView do
  use FormsWeb, :view
  alias FormsWeb.OwnerView

  def render("index.json", %{owner: owner}) do
    %{data: render_many(owner, OwnerView, "owner.json")}
  end

  def render("show.json", %{owner: owner}) do
    %{data: render_one(owner, OwnerView, "owner.json")}
  end

  def render("owner.json", %{owner: owner, token: token}) do
    %{id: owner.id,
      email: owner.email,
      token: token
    }

    end

    def render("signup.json", %{owner: owner, token: token}) do
      %{id: owner.id,
        email: owner.email,
        token: token

      }

      end
end
