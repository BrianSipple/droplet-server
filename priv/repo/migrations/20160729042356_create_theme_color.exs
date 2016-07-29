defmodule Droplet.Repo.Migrations.CreateThemeColor do
  use Ecto.Migration

  def change do
    create table(:theme_colors) do
      add :hue, :integer, null: false
      add :saturation, :integer, null: false
      add :lightness, :integer, null: false
      add :alpha, :decimal, null: false

      add :note_id, references(:notes, on_delete: :nothing)
      timestamps()
    end

  end
end
