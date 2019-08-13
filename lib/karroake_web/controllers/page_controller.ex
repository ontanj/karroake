defmodule KarroakeWeb.PageController do
  use KarroakeWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: Routes.request_path(conn, :index))
  end
end
