defmodule KarroakeWeb.Router do
  use KarroakeWeb, :router

  admin_route = 
  case Application.fetch_env(:karroake, KarroakeWeb.Router) do
    {:ok, [admin_route: admin_route]} -> admin_route
    :error -> "admin"
  end

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

  scope "/", KarroakeWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/sjung", RequestController, :new
    post "/sjung", RequestController, :create
    get "/spellista", RequestController, :index

    get "/" <> admin_route, AdminController, :index
    post "/" <> admin_route, AdminController, :create
    post "/" <> admin_route <> "/played", AdminController, :played
    
  end

  # Other scopes may use custom stacks.
  # scope "/api", KarroakeWeb do
  #   pipe_through :api
  # end
end
