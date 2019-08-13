defmodule KarroakeWeb.AdminController do
  use KarroakeWeb, :controller

  alias Karroake.KaraokeList

  def index(conn, _params) do
    requested = KaraokeList.list_requests(:requested)
    queued = KaraokeList.list_set_songs()
    render(conn, "index.html", requested: requested, queued: queued)
  end

  def create(conn, %{"request" => request_id}) do
    case KaraokeList.create_set_song(request_id) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Låten tillagd!")
       
      {:error, _} ->
        conn
        |> put_flash(:error, "Något gick fel :((")
    end
    |> redirect(to: Routes.admin_path(conn, :index))
  end

  def played(conn, %{"setsong" => setsong_id}) do
    setsong_id
    |> String.to_integer
    |> KaraokeList.played_set_song
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Låten är märkt som spelad.")
       
      {:error, _} ->
        conn
        |> put_flash(:error, "Något gick fel :((")
    end
    |> redirect(to: Routes.admin_path(conn, :index))
  end

  # def delete(conn, %{"id" => id}) do
  #   admin = KaraokeList.get_admin!(id)
  #   {:ok, _admin} = KaraokeList.delete_admin(admin)

  #   conn
  #   |> put_flash(:info, "Admin deleted successfully.")
  #   |> redirect(to: Routes.admin_path(conn, :index))
  # end
end
