defmodule Droplet.SessionView do
  use Droplet.Web, :view

  def render("token.json", %{token: token}) do
    %{token: token}
  end

  def render("login_failed", _) do
    %{errors: ["Invalid identification/password combination!"]}
  end
end
