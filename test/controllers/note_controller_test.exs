defmodule Droplet.NoteControllerTest do
  use Droplet.ConnCase

  alias Droplet.Note
  @valid_attrs %{content: "some content", priority: 42, revision_count: 42, title: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    # Setup the note's containing notebook
    notebook = Repo.insert! %Droplet.Notebook{}

    conn = conn
    |> put_req_header("content-type", "application/vnd.api+json")

    # {:ok, conn: put_req_header(conn, "accept", "application/json")}
    {:ok, conn: conn, data: notebook}
  end

  test "lists all entries on index", %{conn: conn, data: notebook} do
    conn = get conn, notebook_note_path(conn, :index, notebook)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn, data: notebook} do
    note = Repo.insert! %Note{}
    conn = get conn, notebook_note_path(conn, :show, notebook, note)
    assert json_response(conn, 200)["data"] == %{"id" => note.id,
      "title" => note.title,
      "content" => note.content,
      "revision_count" => note.revision_count,
      "priority" => note.priority,
      "notebook_id" => note.notebook_id,
      "theme_color_id" => note.theme_color_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn, data: notebook} do
    assert_error_sent 404, fn ->
      get conn, notebook_note_path(conn, :show, notebook, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, data: notebook} do
    conn = post conn, notebook_note_path(conn, :create, notebook), note: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Note, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, data: notebook} do
    conn = post conn, notebook_note_path(conn, :create, notebook), note: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, data: notebook} do
    note = Repo.insert! %Note{}
    conn = put conn, notebook_note_path(conn, :update, notebook, note), note: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Note, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, data: notebook} do
    note = Repo.insert! %Note{}
    conn = put conn, notebook_note_path(conn, :update, notebook, note), note: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, data: notebook} do
    note = Repo.insert! %Note{}
    conn = delete conn, notebook_note_path(conn, :delete, notebook, note)
    assert response(conn, 204)
    refute Repo.get(Note, note.id)
  end
end
