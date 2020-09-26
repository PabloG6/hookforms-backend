defmodule HaberdashWeb.Router do
  use HaberdashWeb, :router
  use Plug.ErrorHandler
  alias Haberdash.Exception
  require Logger
  import Poison

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {HaberdashWeb.LayoutView, :live}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end
  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Haberdash.Auth.Pipeline
  end

  pipeline :api_key do
    plug Haberdash.Plug.ApiKey
  end

  pipeline :franchise do
    plug Haberdash.Auth.Pipeline
    plug Haberdash.Plug.Franchise
  end

  pipeline :api_key_franchise do
    plug Haberdash.Plug.ApiKeyFranchise
  end

  scope "/api", HaberdashWeb do
    pipe_through :api
    post "/owner", OwnerController, :create
    post "/login", OwnerController, :login
  end

  scope "/api", HaberdashWeb do
    post "/developer/:id", DeveloperController, :create
    get "/developer/:id", DeveloperController, :show
    put "/developer/:id", DeveloperController, :update
    get "/developer", DeveloperController, :index
    patch "/developer/:id", DeveloperController, :index
    delete "/developer/:id", DeveloperController, :delete
  end

  scope "/api", HaberdashWeb do
    pipe_through [:api, :auth, :franchise]
    resources "/keys", ApiKeyController, except: [:new, :edit, :index, :update]
    get "/keys/developer/:id", ApiKeyController, :index
  end

  scope "/", HaberdashWeb do
    live "/checkout", CheckoutLive.Index, :index
    live "/checkout/new", CheckoutLive.Index, :new
    live "/checkout/:id/edit", CheckoutLive.Index, :edit
    live "/checkout/:id", CheckoutLive.Show, :show
    live "/checkout/:id/show/edit", CheckoutLive.Show, :edit
  end

  scope "/api", HaberdashWeb do
    pipe_through [:api, :auth, :franchise]
    resources "/product", ProductsController, except: [:new, :edit]
    resources "/collection", CollectionController, except: [:new, :edit]
    resources "/accessories", AccessoriesController, except: [:new, :edit]
  end

  scope "/api/group", HaberdashWeb do
    pipe_through [:api, :auth, :franchise]
    post "/product/", ProductGroupsController, :create
    get "/product/:id", ProductGroupsController, :show
    delete "/product/:id", ProductGroupsController, :delete
  end

  scope "/api/assoc", HaberdashWeb do
    pipe_through [:api, :auth, :franchise]
    post "/product/:product_id/:accessories_id", ProductAccessoriesController, :create
    get "/product/:product_id/:accessories_id", ProductAccessoriesController, :show
    delete "/product/:product_id", ProductAccessoriesController, :delete
  end

  scope "/api", HaberdashWeb do
    pipe_through [:api]
    resources "/customer", CustomerController, except: [:new, :edit]
  end

  scope "/api", HaberdashWeb do
    pipe_through [:api, :api_key, :api_key_franchise]
    resources "/orders", OrdersController, except: [:new, :edit, :update]
    put "/orders/:id", OrdersController, :update
    patch "/orders/:id", OrdersController, :patch
    post "/orders/:id", OrdersController, :create
  end

  # scope "/api/groups", HaberdashWeb do
  #   pipe_through [:api, :auth, :franchise]
  #   post "/collection/:id", CollectionController, :add_product
  #   delete "/collection/:id", CollectionCtonroller, :remove_product
  #   get "/collection/:id", CollectionController, :index_products
  # end

  scope "/api", HaberdashWeb do
    pipe_through [:api, :auth]
    resources "/owner", OwnerController, except: [:new, :edit, :create]
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

  # handle_errors when inventory_not_found is done within a genserver a tuple is sent
  def handle_errors(%Plug.Conn{} = conn, %{
        kind: :exit,
        reason: {{%Exception.InventoryNotFound{message: message}, _}, _},
        stack: _
      }) do
    Logger.info("exiting from genserver")

    send_resp(conn, 404, encode!(%{message: message, code: :inventory_not_found}))
  end

  def handle_errors(%Plug.Conn{} = conn, %{
        kind: _,
        reason: %Exception.InventoryNotFound{message: message},
        stack: _
      }) do
    send_resp(conn, 404, encode!(%{message: message, code: :inventory_not_found}))
  end

  def handle_errors(%Plug.Conn{} = conn, %{
    kind: _,
    reason: %Exception.IncorrectFormat{message: message},
    stack: _
  }) do
    send_resp(conn, 404, encode!(%{message: message, code: :inventory_not_found}))
  end

  def handle_errors(conn, %{kind: _, reason: _, stack: _}), do: send_resp(conn, conn.status, encode!(%{message: "Something went wrong", code: :server_error}))


end
