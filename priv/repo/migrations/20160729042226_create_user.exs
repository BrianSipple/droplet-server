defmodule Droplet.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false
      add :first_name, :string
      add :last_name, :string
      add :password_hash, :string
      add :twitter_username, :string
      add :avatar_url, :string
      add :bio, :string
      add :location, :string
      add :accessibility, :string
      add :language, :string
      add :last_login, :datetime

      timestamps()
    end

    create unique_index(:users, [:username])

  end
end
