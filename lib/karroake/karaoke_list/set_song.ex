defmodule Karroake.KaraokeList.SetSong do
  use Ecto.Schema
  import Ecto.Changeset

  alias Karroake.KaraokeList.Request

  schema "setsongs" do
    field :played, :boolean, default: false
    belongs_to :request, Request

    timestamps()
  end

  @doc false
  def changeset(set_song, attrs) do
    set_song
    |> cast(attrs, [:played])
    |> validate_required([:played])
  end
end
