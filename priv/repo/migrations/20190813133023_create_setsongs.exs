defmodule Karroake.Repo.Migrations.CreateSetsongs do
  use Ecto.Migration

  def change do
    create table(:setsongs) do
      add :played, :boolean, default: false, null: false
      add :request_id, references(:requests, on_delete: :nothing)

      timestamps()
    end

    create index(:setsongs, [:request_id])
  end
end
