defmodule Droplet.Repo.Migrations.CreateUserPrivateInfo do
  use Ecto.Migration

  def change do
    create table(:user_private_infos) do
      add :email, :string, null: false
      add :subscription_type, :string, null: false

      add :user_id, references(:users, on_delete: :nothing)
      add :role_id, references(:roles, on_delete: :nothing)

      timestamps()
    end

    create index(:user_private_infos, [:user_id])
    create index(:user_private_infos, [:role_id])

    # Unique email across the whole app
    # (supports implementing a corresponding model-level contraint)
    create unique_index(:user_private_infos, [:email])
  end


end
