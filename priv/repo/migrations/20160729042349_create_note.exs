defmodule Droplet.Repo.Migrations.CreateNote do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :title, :string, null: false
      add :content, :string
      add :revision_count, :integer, null: false
      add :priority, :integer, null: false

      add :notebook_id, references(:notebooks, on_delete: :nothing)

      timestamps()
    end
    create index(:notes, [:notebook_id])

    create unique_index(:notes, [:notebook_id, :title])
  end
end
