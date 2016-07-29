defmodule Droplet.NotebookController do
  use Droplet.Web, :controller

  alias Droplet.Notebook

  def index(conn, _params) do
    notebooks = Repo.all(Notebook)
    render(conn, "index.json", notebooks: notebooks)
  end

  def create(conn, %{"notebook" => notebook_params}) do
    changeset = Notebook.changeset(%Notebook{}, notebook_params)

    case Repo.insert(changeset) do
      {:ok, notebook} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", notebook_path(conn, :show, notebook))
        |> render("show.json", notebook: notebook)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Droplet.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    notebook = Repo.get!(Notebook, id)
    render(conn, "show.json", notebook: notebook)
  end

  def update(conn, %{"id" => id, "notebook" => notebook_params}) do
    notebook = Repo.get!(Notebook, id)
    changeset = Notebook.changeset(notebook, notebook_params)

    case Repo.update(changeset) do
      {:ok, notebook} ->
        render(conn, "show.json", notebook: notebook)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Droplet.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    notebook = Repo.get!(Notebook, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(notebook)

    send_resp(conn, :no_content, "")
  end
end
