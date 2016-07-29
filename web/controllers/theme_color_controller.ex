defmodule Droplet.ThemeColorController do
  use Droplet.Web, :controller

  alias Droplet.ThemeColor

  def index(conn, _params) do
    theme_colors = Repo.all(ThemeColor)
    render(conn, "index.json", theme_colors: theme_colors)
  end

  def create(conn, %{"theme_color" => theme_color_params}) do
    changeset = ThemeColor.changeset(%ThemeColor{}, theme_color_params)

    case Repo.insert(changeset) do
      {:ok, theme_color} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", theme_color_path(conn, :show, theme_color))
        |> render("show.json", theme_color: theme_color)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Droplet.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    theme_color = Repo.get!(ThemeColor, id)
    render(conn, "show.json", theme_color: theme_color)
  end

  def update(conn, %{"id" => id, "theme_color" => theme_color_params}) do
    theme_color = Repo.get!(ThemeColor, id)
    changeset = ThemeColor.changeset(theme_color, theme_color_params)

    case Repo.update(changeset) do
      {:ok, theme_color} ->
        render(conn, "show.json", theme_color: theme_color)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Droplet.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    theme_color = Repo.get!(ThemeColor, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(theme_color)

    send_resp(conn, :no_content, "")
  end
end
