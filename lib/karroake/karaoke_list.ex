defmodule Karroake.KaraokeList do
  @moduledoc """
  The KaraokeList context.
  """

  import Ecto.Query, warn: false
  alias Karroake.Repo

  alias Karroake.KaraokeList.Song
  alias Karroake.KaraokeList.SetSong
  alias Karroake.KaraokeList.Request

  @doc """
  Returns the list of songs.

  ## Examples

      iex> list_songs()
      [%Song{}, ...]

  """
  def list_songs do
    Repo.all(Song)
    |> Enum.sort(fn song1, song2 -> String.downcase(song1.artist) < String.downcase(song2.artist) end)
  end

  @doc """
  Gets a single song.

  Raises `Ecto.NoResultsError` if the Song does not exist.

  ## Examples

      iex> get_song!(123)
      %Song{}

      iex> get_song!(456)
      ** (Ecto.NoResultsError)

  """
  def get_song!(id), do: Repo.get!(Song, id)

  @doc """
  Creates a song.

  ## Examples

      iex> create_song(%{field: value})
      {:ok, %Song{}}

      iex> create_song(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_song(attrs \\ %{}) do
    %Song{}
    |> Song.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a song.

  ## Examples

      iex> update_song(song, %{field: new_value})
      {:ok, %Song{}}

      iex> update_song(song, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_song(%Song{} = song, attrs) do
    song
    |> Song.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Song.

  ## Examples

      iex> delete_song(song)
      {:ok, %Song{}}

      iex> delete_song(song)
      {:error, %Ecto.Changeset{}}

  """
  def delete_song(%Song{} = song) do
    Repo.delete(song)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking song changes.

  ## Examples

      iex> change_song(song)
      %Ecto.Changeset{source: %Song{}}

  """
  def change_song(%Song{} = song) do
    Song.changeset(song, %{})
  end

  @doc """
  Returns the list of requests.
  Passing `:requested` as input only lists those not in setlist yet.

  ## Examples

      iex> list_requests()
      [%Request{}, ...]

  """
  def list_requests(:requested) do
    Request
    |> order_by(:id)
    |> preload(:song)
    |> join(:left, [r], ss in assoc(r, :set_song))
    |> where([r, ss], is_nil(ss.id))  
    |> Repo.all()
  end
  def list_requests do
    Request
    |> preload(:song)
    |> order_by(:id)
    |> Repo.all()
  end

  @doc """
  Gets a single request.

  Raises `Ecto.NoResultsError` if the Request does not exist.

  ## Examples

      iex> get_request!(123)
      %Request{}

      iex> get_request!(456)
      ** (Ecto.NoResultsError)

  """
  def get_request!(id), do: Repo.get!(Request, id)

  @doc """
  Get a single request.
  Returns `%Request{}` or `nil` if not found.
  """
  def get_request(id), do: Repo.get(Request, id)

  @doc """
  Creates a request.

  ## Examples

      iex> create_request(%{field: value})
      {:ok, %Request{}}

      iex> create_request(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_request(attrs, song_id) when is_integer(song_id) do
    get_song!(song_id)
    |> Ecto.build_assoc(:requests)
    |> Request.changeset(attrs)
    |> Repo.insert()
  end
  def create_request(attrs, song_id) when is_binary(song_id), do: create_request(attrs, String.to_integer(song_id))
  def create_request(attrs \\ %{})
  def create_request(attrs = %{"song_id" => song_id}), do: create_request(attrs, song_id)
  def create_request(attrs) do
    %Request{}
    |> Request.changeset(attrs)
    |> Repo.insert
  end

  @doc """
  Deletes a Request.

  ## Examples

      iex> delete_request(request)
      {:ok, %Request{}}

      iex> delete_request(request)
      {:error, %Ecto.Changeset{}}

  """
  def delete_request(%Request{} = request) do
    Repo.delete(request)
  end

  @doc """
  Deletes all requests (and set songs).
  """
  def reset_requests, do: Repo.delete_all(Request)

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking request changes.

  ## Examples

      iex> change_request(request)
      %Ecto.Changeset{source: %Request{}}

  """
  def change_request(%Request{} = request) do
    Request.changeset(request, %{})
  end

  @doc """
  Preloads the song to the request.
  """
  def preload_song(%Request{} = request), do: Repo.preload(request, :song)

  @doc """
  Returns a list with set songs.
  If provided, first argument can be `:played` or `:unplayed`
  and in that case only played or unplayed set songs are returned.
  """

  def list_set_songs do
    SetSong
    |> preload([request: ^preload(Request, :song)])
    |> order_by(:id)
    |> Repo.all
  end
  def list_set_songs(:played) do
    SetSong
    |> preload([request: ^preload(Request, :song)])
    |> where(played: true)
    |> order_by(:updated_at)
    |> Repo.all
  end
  def list_set_songs(:unplayed) do
    SetSong
    |> preload([request: ^preload(Request, :song)])
    |> where(played: false)
    |> order_by(:id)
    |> Repo.all
  end

  @doc """
  Gets a single set song.

  Raises `Ecto.NoResultsError` if the SetSong does not exist.

  ## Examples

      iex> get_set_song!(123)
      %Song{}

      iex> get_set_song!(456)
      ** (Ecto.NoResultsError)

  """
  def get_set_song!(id), do: Repo.get!(SetSong, id)

  def get_set_song(id), do: Repo.get(SetSong, id)

  @doc """
  Creates a set song, for provided request_id.
  """
  def create_set_song(request_id) do
    case get_request(request_id) do
      nil -> {:error, :not_found}
      request ->
        request
        |> Ecto.build_assoc(:set_song)
        |> Repo.insert
    end
  end

  @doc """
  Updates a set song.

  ## Examples

      iex> update_set_song(song, %{field: new_value})
      {:ok, %Song{}}

      iex> update_set_song(song, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_set_song(nil, _), do: {:error, :not_found}
  def update_set_song(%SetSong{} = song, attrs) do
    song
    |> SetSong.changeset(attrs)
    |> Repo.update()
  end
  def update_set_song(song_id, attrs) when is_integer(song_id) or is_binary(song_id),
    do: get_set_song(song_id) |> update_set_song(attrs)

  @doc """
  Mark the set song as played.
  """
  def played_set_song(song), do: update_set_song(song, %{played: true})

  @doc """
  Mark the set song as unplayed.
  """
  def unplayed_set_song(song), do: update_set_song(song, %{played: false})

  @doc """
  Deletes a set song.

  ## Examples

      iex> delete_set_song(set_song)
      {:ok, %Request{}}

      iex> delete_set_song(set_song)
      {:error, %Ecto.Changeset{}}

  """
  def delete_set_song(%SetSong{} = set_song) do
    Repo.delete(set_song)
  end

end
