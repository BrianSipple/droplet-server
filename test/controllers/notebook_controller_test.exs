defmodule Droplet.NotebookControllerTest do
  use Droplet.ConnCase

  alias Droplet.TestHelper
  alias Droplet.Notebook

  @valid_attrs %{sort_param_code: "titleAsc", title: "Strawberries"}
  @invalid_attrs %{title: 1}

  setup %{conn: conn} do
    conn = conn
    |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, user } = TestHelper.create_user(%{
      first_name: "Brian",
      last_name: "Sipple",
      username: "bsipple",
      password: "Google123",
      password_confirmation: "Google123"
    })
    {:ok, theme_color } = TestHelper.create_theme_color(%{hue: 44, saturation: 85, lightness: 89, alpha: 0.5})

    {:ok, conn: conn, data: %{user: user, theme_color: theme_color}}
  end

  test "lists all entries on index", %{conn: conn, data: %{user: user, theme_color: theme_color}} do
    create_test_notebooks user, theme_color

    conn = get conn, notebook_path(conn, :index)
    assert Enum.count(json_response(conn, 200)["data"]) == 5
  end

  test "shows chosen resource", %{conn: conn, data: %{user: user, theme_color: theme_color}} do
    {:ok, notebook } = TestHelper.create_notebook(user, theme_color, @valid_attrs)
    conn = get conn, notebook_path(conn, :show, notebook)
    assert json_response(conn, 200)["data"] == %{"id" => notebook.id,
      "title" => notebook.title,
      "sort_param_code" => notebook.sort_param_code,
      "owner_id" => notebook.owner_id}
      # "owner_id" => notebook.owner_id,
      # "theme_color_id" => notebook.theme_color_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, notebook_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, data: %{user: user, theme_color: theme_color}} do
    conn = post conn, notebook_path(conn, :create), notebook: valid_notebook_attrs(%{user: user, theme_color: theme_color})
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Notebook, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, notebook_path(conn, :create), notebook: @invalid_attrs

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, data: %{user: user, theme_color: theme_color}} do
    {:ok, notebook } = TestHelper.create_notebook(user, theme_color, @valid_attrs)
    conn = put conn, notebook_path(conn, :update, notebook), notebook: %{title: "New title"}
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Notebook, %{title: "New title"})
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, data: %{user: user, theme_color: theme_color}} do
    {:ok, notebook } = TestHelper.create_notebook(user, theme_color, @valid_attrs)
    conn = put conn, notebook_path(conn, :update, notebook), notebook: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, data: %{user: user, theme_color: theme_color}} do
    {:ok, notebook } = TestHelper.create_notebook(user, theme_color, @valid_attrs)
    conn = delete conn, notebook_path(conn, :delete, notebook)
    assert response(conn, 204)
    refute Repo.get(Notebook, notebook.id)
  end

  defp create_test_notebooks(user, theme_color) do
    Enum.each ["Strawberries", "Blueberries", "Raspberries"], fn title ->
      Repo.insert! %Notebook{owner_id: user.id, theme_color_id: theme_color.id, title: title}
    end

    # Create two notebooks owned by another user
    {:ok, other_user } = TestHelper.create_user(%{
      first_name: "Guy",
      last_name: "Fawkes",
      username: "#{user.username}__unique",
      password: "Google123",
      password_confirmation: "Google123"
    })

    Enum.each ["Blackberries", "Mintberries"], fn title ->
      Repo.insert! %Notebook{owner_id: other_user.id, theme_color_id: theme_color.id, title: title}
    end
  end

  defp valid_notebook_attrs(%{user: user, theme_color: theme_color}) do
    @valid_attrs
    |> Map.put(:owner_id, user.id)
    |> Map.put(:theme_color_id, theme_color.id)
  end
end
