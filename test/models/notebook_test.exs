defmodule Droplet.NotebookTest do
  use Droplet.ModelCase

  alias Droplet.Notebook

  @valid_attrs %{sort_param_code: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Notebook.changeset(%Notebook{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Notebook.changeset(%Notebook{}, @invalid_attrs)
    refute changeset.valid?
  end
end
