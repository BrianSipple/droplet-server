# Handles error states introduced by Guardians “EnsureAuthenticated” call
defmodule Droplet.AuthErrorHandler do
  use Droplet.Web, :controller

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render(Droplet.ErrorView, "401.json")
  end

  def unauthorized(conn, _params) do
    conn
    |> put_status(403)
    |> render(Droplet.ErrorView, "403.json")
  end
end
