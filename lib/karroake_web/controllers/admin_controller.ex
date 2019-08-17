defmodule KarroakeWeb.AdminController do
  use KarroakeWeb, :controller

  alias Karroake.KaraokeList

  plug BasicAuth, use_config: {:karroake, :auth}

  def index(conn, _params) do
    requested = KaraokeList.list_requests(:requested)
    queued = KaraokeList.list_set_songs(:unplayed)
    played = KaraokeList.list_set_songs(:played)
    render(conn, "index.html", requested: requested, queued: played ++ queued)
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
  
  def delete(conn, %{"request" => "all"}) do
    KaraokeList.reset_requests

    conn
    |> put_flash(:info, "Alla förfrågningar har tagits bort.")
    |> redirect(to: Routes.admin_path(conn, :index))
  end
  def delete(conn, %{"request" => id}) do
    admin = KaraokeList.get_request!(id)
    {:ok, _admin} = KaraokeList.delete_request(admin)

    conn
    |> put_flash(:info, "Förfrågningen har tagits bort.")
    |> redirect(to: Routes.admin_path(conn, :index))
  end

end
