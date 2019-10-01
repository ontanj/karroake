defmodule KarroakeWeb.SongController do
  use KarroakeWeb, :controller

  alias Karroake.KaraokeList
  alias Karroake.KaraokeList.Song

  def new(conn, _params) do
    changeset = KaraokeList.change_song(%Song{})
    songs = KaraokeList.list_songs()
    |> order_songs
    render(conn, "new.html", changeset: changeset, songs: songs)
  end

  def create(conn, %{"song" => request_params}) do
    case KaraokeList.create_song(request_params) do
      {:ok, _song} ->
        conn
        |> put_flash(:info, "Låten är tillagd")
        |> new(nil)
        
      {:error, %Ecto.Changeset{} = changeset} ->
        songs = KaraokeList.list_songs()
        |> order_songs
        conn
        # |> put_flash(:error, "Något gick fel")
        |> render("new.html", changeset: changeset, songs: songs)
    end
  end

  defp order_songs(list), do: Enum.sort(list, fn song1, song2 -> song1.id > song2.id end)

end
