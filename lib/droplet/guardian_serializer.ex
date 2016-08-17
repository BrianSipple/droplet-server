# A serializer for Guardian that tells it how to encode
# and decode a resource into and out of the token.
defmodule Droplet.GuardianSerializer do
  @behaviour GuardianSerializer

  alias Droplet.Repo
  alias Droplet.User

  # Serialize a user FOR a token 
  def for_token(user = %User{}), do: { :ok, "User#{user.id}" }
  def for_token(_), do: { :error, "Unknown resource type" }

  # Deserialize a user FROM a token
  def from_token("User:" <> id), do: { :ok, Repo.get(User, id) }
  def from_token(_), do: { :error, "Unknown resource type" }

end
