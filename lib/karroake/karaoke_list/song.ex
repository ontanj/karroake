defmodule Karroake.KaraokeList.Song do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, []}
  schema "songs" do
    field :artist, :string
    field :song, :string

    timestamps()
  end

  @doc false
  def changeset(song, attrs) do
    song
    |> cast(attrs, [:artist, :song])
    |> validate_required([:artist, :song])
  end
end
