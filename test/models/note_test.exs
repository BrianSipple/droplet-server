defmodule Droplet.NoteTest do
  use Droplet.ModelCase

  alias Droplet.Note

  @valid_attrs %{content: "some content", priority: 42, revision_count: 42, title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Note.changeset(%Note{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Note.changeset(%Note{}, @invalid_attrs)
    refute changeset.valid?
  end
end
