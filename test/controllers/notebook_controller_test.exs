defmodule Droplet.NotebookControllerTest do
  use Droplet.ConnCase

  alias Droplet.Notebook
  @valid_attrs %{sort_param_code: "some content", title: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, notebook_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    notebook = Repo.insert! %Notebook{}
    conn = get conn, notebook_path(conn, :show, notebook)
    assert json_response(conn, 200)["data"] == %{"id" => notebook.id,
      "title" => notebook.title,
      "sort_param_code" => notebook.sort_param_code,
      "owner_id" => notebook.owner_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, notebook_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, notebook_path(conn, :create), notebook: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Notebook, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, notebook_path(conn, :create), notebook: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    notebook = Repo.insert! %Notebook{}
    conn = put conn, notebook_path(conn, :update, notebook), notebook: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Notebook, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    notebook = Repo.insert! %Notebook{}
    conn = put conn, notebook_path(conn, :update, notebook), notebook: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    notebook = Repo.insert! %Notebook{}
    conn = delete conn, notebook_path(conn, :delete, notebook)
    assert response(conn, 204)
    refute Repo.get(Notebook, notebook.id)
  end
end
