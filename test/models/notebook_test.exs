defmodule Droplet.NotebookTest do
  use Droplet.ModelCase

  alias Droplet.Notebook
  alias Droplet.TestHelper

  setup do
    {:ok, user} = TestHelper.create_user(%{first_name: "Brian", last_name: "Sipple",
      username: "bsipple", password: "phoenix123", password_confirmation: "phoenix123"})

    {:ok, %{user: user}}
  end

  @valid_attrs %{sort_param_code: "lastUpdatedAtDesc", title: "Fish"}
  @invalid_attrs %{}

  test "changeset with valid attributes", %{user: user} do
    changeset = Notebook.changeset(%Notebook{}, valid_attrs(%{user: user}))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Notebook.changeset(%Notebook{}, @invalid_attrs)
    refute changeset.valid?
  end

  defp valid_attrs(%{user: user}) do
    @valid_attrs
    |> Map.put(:owner_id, user.id)
  end
end
