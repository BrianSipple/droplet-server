defmodule Droplet.UserPrivateInfoTest do
  use Droplet.ModelCase

  alias Droplet.TestHelper
  alias Droplet.UserPrivateInfo

  setup do
    {:ok, role} = TestHelper.create_role(%{name: "user", admin: false})
    {:ok, user} = TestHelper.create_user(%{first_name: "Brian", last_name: "Sipple",
      username: "bsipple", password: "phoenix123", password_confirmation: "phoenix123"})

    {:ok, %{role: role, user: user}}
  end

  @valid_attrs %{email: "bsipple@example.com", subscription_type: "individualPremium"}
  @invalid_attrs %{}

  test "changeset with valid attributes", %{role: role, user: user} do
    changeset = UserPrivateInfo.changeset(%UserPrivateInfo{}, valid_attrs(%{role: role, user: user}))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserPrivateInfo.changeset(%UserPrivateInfo{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "duplicate `:email`s will be invalid", %{role: role, user: user} do
    %UserPrivateInfo{}
    |> UserPrivateInfo.changeset(valid_attrs(%{role: role, user: user}))
    |> Droplet.Repo.insert!

    info2 =
      %UserPrivateInfo{}
      |> UserPrivateInfo.changeset(valid_attrs(%{role: role, user: user}))

    assert {:error, changeset} = Droplet.Repo.insert(info2)
    assert elem(changeset.errors[:email], 0) == "has already been taken"
  end

  defp valid_attrs(%{role: role, user: user}) do
    @valid_attrs
    |> Map.put(:role_id, role.id)
    |> Map.put(:user_id, user.id)
  end
end
