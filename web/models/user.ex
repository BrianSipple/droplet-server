defmodule Droplet.User do
  defstruct [
    :id,
    :first_name,
    :last_name,
    :username,
    :password,
    :password_confirmation,
    :twitter_username,
    :avatar_url,
    :bio,
    :location,
    :accessibility,
    :language,
    :role,
    :last_login
  ]
end
