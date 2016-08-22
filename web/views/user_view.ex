defmodule Droplet.UserView do
  use Droplet.Web, :view
  use JaSerializer.PhoenixView


  attributes [
    :username,
    :first_name,
    :last_name,
    :password,
    :password_confirmation,
    :password_hash,
    :twitter_username,
    :avatar_url,
    :bio,
    :location,
    :accessibility,
    :language,
    :last_login
  ]

  has_one :user_private_info
    # include: true  # TODO: Proper configuration of side-loaded data
    # field: :private_info # TODO: Consider this naming

  has_many :notebooks
end
