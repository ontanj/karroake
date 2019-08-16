defmodule Karroake.KaraokeList.Song do
  use Ecto.Schema
  import Ecto.Changeset

  alias Karroake.KaraokeList.Request

  @primary_key {:id, :integer, []}
  schema "songs" do
    field :artist, :string
    field :song, :string
    has_many :requests, Request

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(song, attrs) do
    song
    |> cast(attrs, [:id, :artist, :song])
    |> validate_required([:id, :artist, :song])
  end
end
