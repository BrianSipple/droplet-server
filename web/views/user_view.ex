defmodule Droplet.UserView do
  use Droplet.Web, :view
  use JaSerializer.PhoenixView

  alias Droplet.User

  def has_twitter(%User{twitter_username: twitter_username}) do
    !!twitter_username
  end

  def description(%User{username: username}) do
    cond do
      username == "Brian" ->
        "Awesome"
      username == "IronMan" ->
        "SuperCool"
      true ->
        "Nice"
    end
  end
end
