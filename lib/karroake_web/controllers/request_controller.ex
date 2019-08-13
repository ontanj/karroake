defmodule KarroakeWeb.RequestController do
  use KarroakeWeb, :controller

  alias Karroake.KaraokeList
  alias Karroake.KaraokeList.Request

  def index(conn, _params) do
    requests = KaraokeList.list_set_songs(:unplayed)
    past_songs = KaraokeList.list_set_songs(:played)
    past_songs = past_songs
    |> Enum.slice(0-min(10, length(past_songs))..-1)
    render(conn, "index.html", setsongs: requests, pastsongs: past_songs)
  end

  def new(conn, _params) do
    changeset = KaraokeList.change_request(%Request{})
    songs = KaraokeList.list_songs()
    |> Enum.map(fn song -> [key: song.artist <> " - " <> song.song, value: song.id] end)
    render(conn, "new.html", changeset: changeset, songs: songs)
  end

  def create(conn, %{"request" => request_params}) do
    case KaraokeList.create_request(request_params) do
      {:ok, request} ->
        conn
        |> render("show.html", request: KaraokeList.preload_song(request))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    request = KaraokeList.get_request!(id)
    render(conn, "show.html", request: request)
  end

  def edit(conn, %{"id" => id}) do
    request = KaraokeList.get_request!(id)
    changeset = KaraokeList.change_request(request)
    render(conn, "edit.html", request: request, changeset: changeset)
  end

  def update(conn, %{"id" => id, "request" => request_params}) do
    request = KaraokeList.get_request!(id)

    case KaraokeList.update_request(request, request_params) do
      {:ok, request} ->
        conn
        |> put_flash(:info, "Request updated successfully.")
        |> redirect(to: Routes.request_path(conn, :show, request))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", request: request, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    request = KaraokeList.get_request!(id)
    {:ok, _request} = KaraokeList.delete_request(request)

    conn
    |> put_flash(:info, "Request deleted successfully.")
    |> redirect(to: Routes.request_path(conn, :index))
  end
end
