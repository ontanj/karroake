defmodule Karroake.KaraokeList.Request do
  use Ecto.Schema
  import Ecto.Changeset

  alias Karroake.KaraokeList.Song
  alias Karroake.KaraokeList.SetSong

  schema "requests" do
    field :firstname1, :string
    field :firstname2, :string
    field :firstname3, :string
    field :secondname1, :string
    field :secondname2, :string
    field :secondname3, :string
    belongs_to :song, Song
    has_one :set_song, SetSong

    timestamps()
  end

  @doc false
  def changeset(request, attrs) do
    request
    |> cast(attrs, [:firstname1, :secondname1, :firstname2, :secondname2, :firstname3, :secondname3])
    |> validate_required([:song_id, :firstname1, :secondname1])
  end
end
