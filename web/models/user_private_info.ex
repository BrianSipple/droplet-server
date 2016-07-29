defmodule Droplet.UserPrivateInfo do
  use Droplet.Web, :model

  schema "user_private_infos" do

    field :email, :string
    field :subscription_type, :string, default: "basic" # TODO: Make a Ecto type for this Postgres enum (http://stackoverflow.com/questions/35245859/how-to-use-postgres-enumerated-type-with-ecto)

    belongs_to :user, Droplet.User
    belongs_to :role, Dropet.Role

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :subscription_type, :user_id, :role_id])
    |> validate_required([:email, :subscription_type, :user_id, :role_id])
    |> validate_inclusion(:subscription_type, ["basic", "individualStandard", "individualPremium", "teamStandard", "teamPremium"])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end
end
