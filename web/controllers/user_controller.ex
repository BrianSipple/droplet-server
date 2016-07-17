defmodule Droplet.UserController do
  use Droplet.Web, :controller

  alias Droplet.User


  def index(conn, _params) do
    users = Repo.all(User)
    render conn, "index.json", data: users
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.json", data: user)
  end
end
