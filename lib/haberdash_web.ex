defmodule HaberdashWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use HaberdashWeb, :controller
      use HaberdashWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: HaberdashWeb
      import Phoenix.LiveView.Controller
      import Plug.Conn
      import HaberdashWeb.Gettext
      alias HaberdashWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/haberdash_web/templates",
        namespace: HaberdashWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]
      import Phoenix.LiveView.Helpers
      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Phoenix.LiveView.Router
      import Plug.Conn
      import Phoenix.LiveView.Router
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import HaberdashWeb.Gettext
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {HaberdashWeb.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent
      unquote(view_helpers())

    end
  end

  defp view_helpers do
    quote do
      use Phoenix.HTML
      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      #use the live helpers (live_modal etc)
      import HaberdashWeb.LiveHelpers
      import HaberdashWeb.ErrorHelpers
      import HaberdashWeb.Gettext
      alias HaberdashWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
