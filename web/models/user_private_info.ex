defmodule Droplet.UserPrivateInfo do
  use Droplet.Web, :model

  schema "user_private_infos" do

    field :email, :string
    field :subscription_type, :string

    belongs_to :user, Droplet.User
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :subscription_type])
    |> validate_required([:email, :subscription_type])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end
end
