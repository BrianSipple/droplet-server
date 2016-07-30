defmodule Droplet.ThemeColorControllerTest do
  use Droplet.ConnCase

  alias Droplet.ThemeColor
  @valid_attrs %{alpha: 0.9, hue: 42, lightness: 42, saturation: 42}
  @invalid_attrs %{alpha: 1.1}

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, theme_color_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    theme_color = Repo.insert! ThemeColor.changeset(%ThemeColor{}, @valid_attrs)
    conn = get conn, theme_color_path(conn, :show, theme_color)
    assert json_response(conn, 200)["data"] == %{"id" => theme_color.id,
      "hue" => theme_color.hue,
      "saturation" => theme_color.saturation,
      "lightness" => theme_color.lightness,
      "alpha" => Decimal.to_string(theme_color.alpha)}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, theme_color_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, theme_color_path(conn, :create), theme_color: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(ThemeColor, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, theme_color_path(conn, :create), theme_color: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    theme_color = Repo.insert! ThemeColor.changeset(%ThemeColor{}, @valid_attrs)

    new_attrs = Dict.merge(@valid_attrs, %{hue: 3})
    conn = put conn, theme_color_path(conn, :update, theme_color), theme_color: new_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(ThemeColor, new_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    theme_color = Repo.insert! %ThemeColor{}
    conn = put conn, theme_color_path(conn, :update, theme_color), theme_color: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    theme_color = Repo.insert! %ThemeColor{}
    conn = delete conn, theme_color_path(conn, :delete, theme_color)
    assert response(conn, 204)
    refute Repo.get(ThemeColor, theme_color.id)
  end
end
