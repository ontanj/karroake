defmodule Karroake.KaraokeList.Request do
  use Ecto.Schema
  import Ecto.Changeset

  alias Karroake.KaraokeList.Song

  schema "requests" do
    field :firstname1, :string
    field :firstname2, :string
    field :firstname3, :string
    field :status, :integer, default: 0
    field :secondname1, :string
    field :secondname2, :string
    field :secondname3, :string
    belongs_to :song, Song

    timestamps()
  end

  @doc false
  def changeset(request, attrs) do
    request
    |> cast(attrs, [:firstname1, :secondname1, :firstname2, :secondname2, :firstname3, :secondname3, :status])
    |> validate_required([:firstname1, :secondname1])
  end
end
