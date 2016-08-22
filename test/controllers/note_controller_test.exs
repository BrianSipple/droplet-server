defmodule Droplet.NoteControllerTest do
  require Logger
  use Droplet.ConnCase

  alias Droplet.Note
  alias Droplet.TestHelper

  @valid_attrs %{content: "Blue", priority: 1, revision_count: 42, title: "Clues"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    # Setup the note's containing notebook
    {:ok, user} = TestHelper.create_user(%{
      first_name: "Brian",
      last_name: "Sipple",
      username: "bsipple",
      password: "Google123",
      password_confirmation: "Google123"
    })
    {:ok, theme_color} = TestHelper.create_theme_color(%{hue: 44, saturation: 85, lightness: 89, alpha: 0.5})
    {:ok, notebook} = TestHelper.create_notebook(user, theme_color, %{title: "Fruits", sort_param_code: "lastUpdatedAtDesc"})

    { :ok, jwt, _ } = Guardian.encode_and_sign(user, :token)

    conn =
      conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")
      |> put_req_header("authorization", "Bearer #{jwt}")


    {:ok, conn: conn, data: %{notebook: notebook, user: user, theme_color: theme_color}}
  end

  test "lists all entries on index", %{conn: conn, data: %{user: user, notebook: notebook, theme_color: theme_color}} do
    create_test_notes %{user: user, notebook: notebook, theme_color: theme_color}
    conn = get conn, notebook_note_path(conn, :index, notebook)

    assert Enum.count(json_response(conn, 200)["data"]) == 6
  end

  test "shows chosen resource", %{conn: conn, data: %{user: _user, notebook: notebook, theme_color: theme_color}} do
    # note = Repo.insert! %Note{}
    attrs = Map.put(@valid_attrs, :title, "Surviving Russian Winters")
    {:ok, note} = TestHelper.create_note(notebook, theme_color, attrs)

    conn = get conn, notebook_note_path(conn, :show, notebook, note)
    assert json_response(conn, 200)["data"] == %{
      "id" => to_string(note.id),
      "type" => "note",
      "attributes" => %{
        "title" => note.title,
        "content" => note.content,
        "revision-count" => note.revision_count,
        "priority" => note.priority
        # "notebook_id" => note.notebook_id,
        # "theme_color_id" => note.theme_color_id
      }
    }
  end

  test "renders page not found when id is nonexistent", %{conn: conn, data: %{user: _user, notebook: notebook, theme_color: _theme_color}} do
    assert_error_sent 404, fn ->
      get conn, notebook_note_path(conn, :show, notebook, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, data: %{user: _user, notebook: notebook, theme_color: theme_color}} do
    Logger.debug("Create note test")
    conn = post conn, notebook_note_path(conn, :create, notebook), note: valid_note_attrs(%{notebook: notebook, theme_color: theme_color})
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Note, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, data: %{user: _user, notebook: notebook, theme_color: _theme_color}} do
    conn = post conn, notebook_note_path(conn, :create, notebook), note: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, data: %{user: _user, notebook: notebook, theme_color: theme_color}} do
    {:ok, note } = TestHelper.create_note(notebook, theme_color, @valid_attrs)
    conn = put conn, notebook_note_path(conn, :update, notebook, note), note: %{title: "New title"}
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Note, %{title: "New title"})
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, data: %{user: _user, notebook: notebook, theme_color: _theme_color}} do
    note = Repo.insert! %Note{}
    conn = put conn, notebook_note_path(conn, :update, notebook, note), note: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, data: %{user: _user, notebook: notebook, theme_color: _theme_color}} do
    note = Repo.insert! %Note{}
    conn = delete conn, notebook_note_path(conn, :delete, notebook, note)
    assert response(conn, 204)
    refute Repo.get(Note, note.id)
  end


  defp create_test_notes(%{user: user, notebook: notebook, theme_color: theme_color}) do
    Enum.each ["Strawberries", "Blueberries", "Blackberries"], fn name ->
      Repo.insert! %Note{title: name, notebook_id: notebook.id, theme_color_id: theme_color.id}
    end

    # {:ok, other_notebook} = TestHelper.create_notebook(user, theme_color, %{title: "Vegetables"})
    {:ok, other_notebook} = TestHelper.create_notebook(user, theme_color)

    Enum.each ["Broccoli", "Carrorts", "Kale"], fn name ->
      Repo.insert! %Note{title: name, notebook_id: other_notebook.id, theme_color_id: theme_color.id}
    end
  end

  defp valid_note_attrs(%{notebook: notebook, theme_color: theme_color}) do
    @valid_attrs
    |> Map.put(:notebook_id, notebook.id)
    |> Map.put(:theme_color_id, theme_color.id)
  end
end
