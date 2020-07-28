defmodule HaberdashWeb.Router do
  use HaberdashWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Haberdash.Auth.Pipeline
  end

  scope "/api", HaberdashWeb do
    pipe_through :api
    post "/owner", OwnerController, :create
    resources "/developer", DevelopersController, except: [:new, :edit, :create]
  end

  scope "/api", HaberdashWeb do
    pipe_through [:api, :auth]
    resources "/owner", OwnerController, except: [:new, :edit, :create]

    resources "/product", ProductsController, except: [:new, :edit]
    resources "/franchise", FranchiseController, except: [:new, :edit]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: HaberdashWeb.Telemetry
    end
  end
end
