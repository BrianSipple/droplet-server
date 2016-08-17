defmodule Droplet.SessionController do
  use Droplet.Web, :controller

  alias Droplet.Repo
  alias Droplet.SessionHandler

  import Ecto.Query, only: [where: 2]
  import Comeonin.Bcrypt
  import Logger

  alias Droplet.User

  def create(conn, %{
    "grant_type" => "password",
    "username" => username,
    "password" => password
  }) do

    case SessionHandler.login(%{identification: username, password: password}, Repo) do
      {:ok, user} ->
        # Sucessfull login!
        Logger.info "User " <> username <> " just logged in"
        # Encode a JWT
        { :ok, jwt, _ } = Guardian.encode_and_sign(user, :token)

        conn
        |> assign(:current_user, user)
        |> put_session(:current_user_id, user.id)
        |> render("token.json", %{token: jwt})  # Return our token to the client

      # {:error} -> login_failed(conn) # TODO: Implement login_failed helper
      {:error} ->
        Logger.warn "User " <> username <> " just failed to login"
        conn
        |> put_status(401)
        |> render(Droplet.ErrorView, "401.json")
    end
  end

  def create(conn, %{"grant_type" => _}) do
    throw "Unsupported grant_type"
  end

  # defp login_failed(conn) do
  #   conn
  #   |> render("login_failed.json", %{})
  #   |> halt
  # end

end
