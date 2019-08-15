defmodule Karroake.Repo.Migrations.CascadeDeletions do
  use Ecto.Migration

  def change do
    alter table(:requests) do
      modify :song_id, references(:songs, on_delete: :delete_all), from: references(:songs, on_delete: :nothing)
    end
    alter table(:setsongs) do
      modify :request_id, references(:requests, on_delete: :delete_all), from: references(:requests, on_delete: :nothing)
    end
  end
end
