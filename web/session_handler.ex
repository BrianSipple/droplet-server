defmodule Droplet.SessionHandler do
  use Droplet.Web, :controller

  import Logger

  alias Droplet.User
  alias Droplet.Repo
  alias Plug.Conn
  alias Comeonin.Bcrypt


  def login(params, repo) do
    user = get_user_from_identification(params["identification"], repo)

    Logger.info "#login, Attempting to authenticate user with name of " <> user.username <> ", password of " <> params["password"] <> ", password hash of " <> user.password_hash

    case authenticate(user, params["password"]) do
      true -> { :ok, user }
      _ -> {:error}
    end
  end

  def current_user(conn) do
    conn.assigns[:current_user]
  end

  def logged_in?(conn), do: !!current_user(conn)


  defp authenticate(user, password) do
    case user do
      nil ->
        Bcrypt.dummy_checkpw()  # simulate a check anyway to prevent timing attacks
        false
      _ -> Bcrypt.checkpw(password, user.password_hash)
    end
  end

  defp get_user_from_identification(identification, repo) do
    if String.contains?(identification, "@") do
      user_private_info = repo.get_by(UserPrivateInfo, email: identification)

      repo.get(User, user_private_info.user_id)
    else
      repo.get_by(User, username: identification)  # Otherwise, treat the identification as the username
    end
  end
end
