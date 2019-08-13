defmodule Karroake.Repo.Migrations.CreateSongs do
  use Ecto.Migration

  def change do
    create table(:songs, primary_key: false) do
      add :id, :integer, primary_key: true
      add :artist, :string, null: false
      add :song, :string, null: false

      timestamps()
    end

  end
end
