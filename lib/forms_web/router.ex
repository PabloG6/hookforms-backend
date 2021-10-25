defmodule FormsWeb.Router do
  use FormsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Forms.Auth.Pipeline
  end

  scope "/", FormsWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", FormsWeb do
    pipe_through [:api, :auth]
    resources "/forms", FormController, except: [:new, :edit]

  end




  scope "/api", FormsWeb do
    pipe_through [:api]
    resources "/owner", OwnerController, except: [:new, :edit, :create]
    post "/signup", OwnerController, :create
    post "/login", OwnerController, :login
  end



  scope "/api", FormsWeb do
    post "/owner", OwnerController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", FormsWeb do
  #   pipe_through :api
  # end

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
      pipe_through :browser
      live_dashboard "/dashboard", metrics: FormsWeb.Telemetry
    end


  end
end
