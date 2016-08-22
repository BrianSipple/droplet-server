defmodule Droplet.SessionController do
  use Droplet.Web, :controller

  alias Droplet.Repo
  alias Droplet.SessionHandler

  import Ecto.Query, only: [where: 2]
  import Comeonin.Bcrypt
  import Logger

  alias Droplet.User


  def create(conn, %{"grant_type" => "password", "session" => session_params}) do
    case SessionHandler.login(session_params, Repo) do
      {:ok, user} ->
        # Sucessfull login!
        Logger.info "User with identification `" <> session_params["identification"] <> "` just logged in"
        # Encode a JWT
        { :ok, jwt, _ } = Guardian.encode_and_sign(user, :token)

        conn
        |> assign(:current_user, user)
        |> fetch_session
        |> put_session(:current_user_id, user.id)
        |> render("token.json", %{token: jwt})  # Return our token to the client

      # {:error} -> login_failed(conn)
      {:error} ->
        Logger.warn "User " <> session_params["identification"] <> " just failed to login"
        conn
        |> put_status(401)
        |> render(Droplet.ErrorView, "401.json")
    end
  end

  def create(conn, %{"grant_type" => _, "session_params" => _}) do
    throw "Unsupported grant_type"
  end

  # defp login_failed(conn) do
  #   conn
  #   |> render("login_failed.json", %{})
  #   |> halt
  # end

end
