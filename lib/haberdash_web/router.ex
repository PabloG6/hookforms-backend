defmodule HaberdashWeb.Router do
  use HaberdashWeb, :router
  use Plug.ErrorHandler
  alias Haberdash.Exception
  require Logger
  import Poison

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
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



  scope "/api", HaberdashWeb do
    pipe_through [:api, :auth, :franchise]
    resources "/products", ProductsController, except: [:new, :edit]
    resources "/collection", CollectionController, except: [:new, :edit]
  end

  scope "/api/group", HaberdashWeb do
    pipe_through [:api, :auth, :franchise]
    post "/products/", ProductGroupsController, :create
    get "/products/:id", ProductGroupsController, :show
    delete "/products/:id", ProductGroupsController, :delete
  end

  scope "/api/assoc", HaberdashWeb do
    pipe_through [:api, :auth, :franchise]
    post "/products/:product_id/:accessories_id", ProductAssocController, :create
    get "/products/:product_id/:accessories_id", ProductAssocController, :show
    delete "/products/:product_id", ProductAssocController, :delete
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

  def handle_errors(conn, %{kind: _, reason: %Ecto.NoResultsError{}, stack: _}) do
    send_resp(conn, conn.status, encode!(%{message: "The requested resource does not exist.", code: :not_found}))
  end

  def handle_errors(conn, %{kind: _, reason: _, stack: _}),
    do:
      send_resp(
        conn,
        conn.status,
        encode!(%{message: "An unexpected error has occured.", code: :server_error})
      )
end
