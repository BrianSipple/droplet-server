defmodule Droplet.NoteTest do
  use Droplet.ModelCase

  alias Droplet.Note
  alias Droplet.TestHelper

  setup do
    {:ok, theme_color} = TestHelper.create_theme_color(%{hue: 44, saturation: 55, lightness: 100, alpha: 0.9})
    {:ok, user} = TestHelper.create_user(%{first_name: "Brian", last_name: "Sipple",
      username: "bsipple", password: "phoenix123", password_confirmation: "phoenix123"})

    {:ok, notebook} = TestHelper.create_notebook(user, theme_color, %{title: "Major Keys"})

    {:ok, %{notebook: notebook, theme_color: theme_color}}
  end

  @valid_attrs %{content: "some content", priority: 1, revision_count: 42, title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes", %{notebook: notebook, theme_color: theme_color} do
    changeset = Note.changeset(%Note{}, valid_attrs(%{notebook: notebook, theme_color: theme_color}))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Note.changeset(%Note{}, @invalid_attrs)
    refute changeset.valid?
  end

  defp valid_attrs(%{notebook: notebook, theme_color: theme_color}) do
    @valid_attrs
    |> Map.put(:notebook_id, notebook.id)
    |> Map.put(:theme_color_id, theme_color.id)
  end
end
