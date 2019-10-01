defmodule KarroakeWeb.RequestController do
  use KarroakeWeb, :controller

  alias Karroake.KaraokeList
  alias Karroake.KaraokeList.Request

  @nbr_of_songs_in_history 5

  defp get_past_songs do
    past_songs = KaraokeList.list_set_songs(:played)
    Enum.slice(past_songs, 0-min(@nbr_of_songs_in_history, length(past_songs))..-1)
  end

  def index(conn, _params) do
    requests = KaraokeList.list_set_songs(:unplayed)
    past_songs = get_past_songs()
    render(conn, "index.html", setsongs: requests, pastsongs: past_songs)
  end

  def new(conn, _params) do
    changeset = KaraokeList.change_request(%Request{})
    render_new(conn, changeset)
  end

  defp render_new(conn,  changeset) do
    pastsongs = get_past_songs()
    setsongs = KaraokeList.list_set_songs(:unplayed)
    songs = KaraokeList.list_songs()
    |> Enum.sort(fn song1, song2 -> String.downcase(song1.artist) < String.downcase(song2.artist) end)
    |> Enum.map(fn song -> [key: song.artist <> " - " <> song.song, value: song.id] end)
    render(conn, "new.html", changeset: changeset, songs: songs, setsongs: setsongs, pastsongs: pastsongs)
  end

  def create(conn, %{"request" => request_params}) do
    case KaraokeList.create_request(request_params) do
      {:ok, request} ->
        conn
        |> render("show.html", request: KaraokeList.preload_song(request))

      {:error, %Ecto.Changeset{} = changeset} ->
        render_new(conn, changeset)
    end
  end

  def delete(conn, %{"request" => "all"}) do
    KaraokeList.reset_requests

    conn
    |> put_flash(:info, "Alla förfrågningar har tagits bort.")
    |> redirect(to: Routes.admin_path(conn, :index))
  end
  def delete(conn, %{"request" => id}) do
    admin = KaraokeList.get_request!(id)
    {:ok, _request} = KaraokeList.delete_request(admin)

    conn
    |> put_flash(:info, "Förfrågningen har tagits bort.")
    |> redirect(to: Routes.admin_path(conn, :index))
  end

end
