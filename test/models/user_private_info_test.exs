defmodule Droplet.UserPrivateInfoTest do
  use Droplet.ModelCase

  alias Droplet.UserPrivateInfo

  @valid_attrs %{email: "bsipple@example.com", subscription_type: "premium"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserPrivateInfo.changeset(%UserPrivateInfo{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserPrivateInfo.changeset(%UserPrivateInfo{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "duplicate `:email`s will be invalid" do
    %UserPrivateInfo{}
    |> UserPrivateInfo.changeset(@valid_attrs)
    |> Droplet.Repo.insert!

    info2 =
      %UserPrivateInfo{}
      |> UserPrivateInfo.changeset(@valid_attrs)

    assert {:error, changeset} = Droplet.Repo.insert(info2)
    assert elem(changeset.errors[:email], 0) == "has already been taken"
  end
end
