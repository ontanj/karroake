defmodule Karroake.Repo.Migrations.CreateRequests do
  use Ecto.Migration

  def change do
    create table(:requests) do
      add :firstname1, :string
      add :secondname1, :string
      add :firstname2, :string
      add :secondname2, :string
      add :firstname3, :string
      add :secondname3, :string
      add :status, :int, default: 0, null: false
      add :song_id, references(:songs, on_delete: :nothing)

      timestamps()
    end

    create index(:requests, [:song_id])
  end
end
