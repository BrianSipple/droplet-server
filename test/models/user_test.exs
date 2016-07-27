defmodule Droplet.UserTest do
  use Droplet.ModelCase

  alias Droplet.User

  @valid_attrs %{
    first_name: "Brian",
    last_name: "Sipple",
    username: "bsipple",
    password: "linkedIn123",
    password_confirmation: "linkedIn123"
  }

  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "mismatched :password and :password_confirmation is invalid" do
    changeset = User.changeset(%User{}, %{
      username: "bsipple",
      password: "google123",
      password_confirmation: "linkedIn123"
    })
    refute changeset.valid?
    assert elem(changeset.errors[:password_confirmation], 0) == "Password confirmation does not match original"
  end

  test "missing password_confirmation is invalid" do
    changeset = User.changeset(%User{}, %{
      username: "bsipple",
      password: "hematite"
    })
    refute changeset.valid?
  end

  test "duplicate `:username`s will be invalid" do
    %User{}
    |> User.changeset(@valid_attrs)
    |> Droplet.Repo.insert!

    user2 =
      %User{}
      |> User.changeset(@valid_attrs)

    assert {:error, changeset} = Droplet.Repo.insert(user2)
    assert elem(changeset.errors[:username], 0) == "has already been taken"
  end
end
