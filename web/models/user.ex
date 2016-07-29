defmodule Droplet.User do
  use Droplet.Web, :model

  schema "users" do

    field :first_name, :string
    field :last_name, :string
    field :username, :string

    # Virtual fields are used for object creation and validation,
    # but are not serialized to the database.
    # Also, they can optionally not be type-checked by declaring type :any.
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :twitter_username, :string
    field :avatar_url, :string
    field :bio, :string
    field :location, :string
    field :accessibility, :string
    field :language, :string
    field :last_login, Ecto.DateTime

    has_one :user_private_info, Droplet.UserPrivateInfo
    has_many :notebooks, Droplet.Notebook

    timestamps()
  end


  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
        :first_name,
        :last_name,
        :username,
        :password,
        :password_confirmation,
        :password_hash,
        :twitter_username,
        :avatar_url,
        :bio,
        :location,
        :accessibility,
        :language,
        :last_login
      ])
    |> validate_required([:username, :password, :password_confirmation])
    |> validate_length(:username, min: 3)
    |> validate_length(:username, max: 24)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password, message: "Password confirmation does not match original")
    |> hash_password
    |> unique_constraint(:username)
  end

  defp hash_password(%{valid?: false} = changeset), do: changeset
  defp hash_password(%{valid?: true} = changeset) do
    hashed_password = Comeonin.Bcrypt.hashpwsalt(Ecto.Changeset.get_field(changeset, :password))
    Ecto.Changeset.put_change(changeset, :password_hash, hashed_password)
  end
end
