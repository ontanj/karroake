defmodule KarroakeWeb.Router do
  use KarroakeWeb, :router

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

  pipeline :authenticated do
    plug BasicAuth, use_config: {:karroake, :auth}
  end

  scope "/", KarroakeWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/sjung", RequestController, :new
    post "/sjung", RequestController, :create
    get "/spellista", RequestController, :index

    scope "/" do
      pipe_through :authenticated

      delete "/request", RequestController, :delete
      get "/admin", AdminController, :index
      post "/admin", AdminController, :create
      delete "/admin", AdminController, :delete
      post "/admin/played", AdminController, :played
      post "/admin/unplayed", AdminController, :unplayed
    end
    
  end

  # Other scopes may use custom stacks.
  # scope "/api", KarroakeWeb do
  #   pipe_through :api
  # end
end
