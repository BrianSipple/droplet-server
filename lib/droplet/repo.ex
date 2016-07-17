defmodule Droplet.Repo do
  use Ecto.Repo, otp_app: :droplet

  # @moduledoc """
  # In-memory repository
  # """
  #
  # def all(Droplet.User) do
  #   [
  #     %Droplet.User{
  #       id: "1",
  #       username: "Brian",
  #       first_name: "Brian",
  #       last_name: "Sipple",
  #       password: "Google123",
  #       password_confirmation: "Google123",
  #       twitter_username: "@BrianSipple",
  #       bio: "Nice person"
  #     },
  #     %Droplet.User{
  #       id: "2",
  #       username: "IronMan",
  #       first_name: "Tony",
  #       last_name: "Stark",
  #       password: "Monkey123",
  #       password_confirmation: "Monkey123",
  #       twitter_username: "@Iron_Man",
  #       bio: "Genius, billionaire, playboy, philanthropist."
  #     },
  #     %Droplet.User{
  #       id: "3",
  #       username: "cap",
  #       first_name: "Steve",
  #       last_name: "Rogers",
  #       password: "Password123",
  #       password_confirmation: "Password123"
  #     }
  #   ]
  # end
  #
  # def all(_module), do: []
  #
  # def get(module, id) do
  #   Enum.find all(module), fn map -> map.id == id end
  # end
  #
  # def get_by(module, params) do
  #   Enum.find all(module), fn map ->
  #     Enum.all?(params, fn {key, val} -> Map.get(map, key) == val end)
  #   end
  # end

end
