defmodule Droplet.UserController do
  use Droplet.Web, :controller

  def index(conn, _params) do
    users = Repo.all(Droplet.User)
    render conn, "index.html", users: users
  end
end
