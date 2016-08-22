defmodule Droplet.UserController do
  use Droplet.Web, :controller
  require Logger

  alias Droplet.User

  # plug Guardian.Plug.EnsureAuthenticated, handler: Droplet.AuthErrorHandler

  # plug :scrub_params, "data" when action in [:create, :update] # TODO: Delete if determined that this isn't our use case

  def index(conn, _params) do
    users = Repo.all(User)
    render conn, "index.json", data: users
  end

  def create(conn, %{"data" => %{"attributes" => user_params}}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
          |> put_status(:created)
          |> put_resp_header("location", user_path(conn, :show, user))
          |> render(:show, data: user)
      {:error, changeset} ->
        conn
          |> put_status(:unprocessable_entity)
          |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, :show, data: user)
  end

  # TODO: Implement
  # def current(conn, _) do
  #   user =
  #     conn
  #     |> Guardian.Plug.current_resource
  #
  #   conn
  #   |> render(Droplet.UserView, "show.json", data: user)
  # end

  def update(conn, %{"id" => id, "data" => %{"attributes" => user_params} }) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, :show, data: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Droplet.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end
end
