defmodule Droplet.Repo.Migrations.CreateUserPrivateInfo do
  use Ecto.Migration

  def change do
    create table(:user_private_infos) do
      add :email, :string
      add :subscription_type, :string

      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:user_private_infos, [:user_id])

    # Unique email across the whole app
    # (supports implementing a corresponding model-level contraint)
    create unique_index(:user_private_infos, [:email])
  end


end
