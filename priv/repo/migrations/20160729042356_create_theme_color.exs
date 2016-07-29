defmodule Droplet.Repo.Migrations.CreateThemeColor do
  use Ecto.Migration

  def change do
    create table(:theme_colors) do
      add :hue, :integer, null: false
      add :saturation, :integer, null: false
      add :lightness, :integer, null: false
      add :alpha, :decimal, null: false

      timestamps()
    end

  end
end
