defmodule Karroake.Repo.Migrations.DeleteStatusField do
  use Ecto.Migration

  def up do
    alter table(:requests) do
      remove :status
    end
  end

  def down do
    alter table(:requests) do
      add :status, :int, default: 0, null: false
    end
  end
  
end
