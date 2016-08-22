defmodule Droplet.NoteController do
  require Logger

  use Droplet.Web, :controller
  alias Droplet.Note

  plug :assign_notebook
  plug Guardian.Plug.EnsureAuthenticated, handler: Droplet.AuthErrorHandler

  def index(conn, _params) do
    notes = Repo.all(Note)
    render(conn, "index.json", notes: notes)
  end

  def create(conn, %{"note" => note_params}) do
    changeset = Note.changeset(%Note{}, note_params)

    case Repo.insert(changeset) do
      {:ok, note} ->
        conn
        |> put_status(:created)
        # |> put_resp_header("location", notebook_note_path(conn, :show, note))
        |> put_resp_header("location", notebook_note_path(conn, :show, conn.assigns[:notebook], note))
        |> render("show.json", note: note)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Droplet.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    note = Repo.get!(Note, id)
    render(conn, "show.json", note: note)
  end

  def update(conn, %{"id" => id, "note" => note_params}) do
    note = Repo.get!(Note, id)
    changeset = Note.changeset(note, note_params)

    case Repo.update(changeset) do
      {:ok, note} ->
        render(conn, "show.json", note: note)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Droplet.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    note = Repo.get!(Note, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(note)

    send_resp(conn, :no_content, "")
  end

  defp assign_notebook(conn, _opts) do
    case conn.params do
      %{"notebook_id" => notebook_id} ->
        case Repo.get(Droplet.Notebook, notebook_id) do
          # nil -> invalid_notebook(conn) 📝 TODO: Implement?
          nil -> Logger.error("Invalid notebook")
          notebook -> assign(conn, :notebook, notebook)
        end
      _ ->
        # invalid_notebook(conn)
        Logger.error("Invalid notebook")
    end
  end
end
