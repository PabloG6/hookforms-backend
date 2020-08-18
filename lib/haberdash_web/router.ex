defmodule HaberdashWeb.Router do
  use HaberdashWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Haberdash.Auth.Pipeline
  end

  pipeline :franchise do
    plug Haberdash.Auth.Pipeline
    plug Haberdash.Plug.Franchise
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
    resources "/product", ProductsController, except: [:new, :edit]
    resources "/collection", CollectionController, except: [:new, :edit]
    resources "/accessories", AccessoriesController, except: [:new, :edit]


  end

  @doc """
  modify which groups products belong to.
  """
  scope "/api/groups", HaberdashWeb do
    pipe_through [:api, :auth, :franchise]
    post "/product/:product_id", ProductGroupsController, :create
    get "/product/:id", ProductGroupsController, :show
    delete "/product/:id", ProductGroupsController, :delete
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
end
