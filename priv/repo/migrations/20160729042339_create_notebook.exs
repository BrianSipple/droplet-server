defmodule Droplet.Repo.Migrations.CreateNotebook do
  use Ecto.Migration

  def change do
    create table(:notebooks) do
      add :title, :string, null: false
      add :sort_param_code, :string, null: false

      add :owner_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:notebooks, [:owner_id])

    create unique_index(:notebooks, [:title])
  end
end
