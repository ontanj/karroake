defmodule KarroakeWeb.AdminController do
  use KarroakeWeb, :controller

  alias Karroake.KaraokeList

  def index(conn, _params) do
    requested = KaraokeList.list_requests(:requested)
    queued = KaraokeList.list_set_songs(:unplayed)
    played = KaraokeList.list_set_songs(:played)
    render(conn, "index.html", requested: requested, queued: queued, played: played)
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

  def unplayed(conn, %{"setsong" => setsong_id}) do
    setsong_id
    |> KaraokeList.unplayed_set_song
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Låten är märkt som ospelad.")
       
      {:error, _} ->
        conn
        |> put_flash(:error, "Något gick fel :((")
    end
    |> redirect(to: Routes.admin_path(conn, :index))
  end
  
  def delete(conn, %{"setsong" => id}) do
    set_song = KaraokeList.get_set_song!(id)
    {:ok, _set_song} = KaraokeList.delete_set_song(set_song)

    conn
    |> put_flash(:info, "Låten har tagits bort från spellistan.")
    |> redirect(to: Routes.admin_path(conn, :index))
  end

end
