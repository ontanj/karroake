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

  scope "/", KarroakeWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/sjung", RequestController, :new
    post "/sjung", RequestController, :create
    get "/spellista", RequestController, :index

    get "/admin", AdminController, :index
    post "/admin", AdminController, :create
    post "/admin/played", AdminController, :played
    
  end

  # Other scopes may use custom stacks.
  # scope "/api", KarroakeWeb do
  #   pipe_through :api
  # end
end
