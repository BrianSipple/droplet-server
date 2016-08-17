# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Droplet.Repo.insert!(%Droplet.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Droplet.Repo
alias Droplet.User
alias Droplet.Role
alias Droplet.UserPrivateInfo


user =
  User.changeset(%User{}, %{
    username: "bsipple",
    first_name: "Brian",
    last_name: "Sipple",
    password: "testPassword123",
    password_confirmation: "testPassword123"
  })
  |> Repo.insert!()

role =
  Role.changeset(%Role{}, %{name: "test role", admin: true})
  |> Repo.insert!()

user
  |> Ecto.build_assoc(:user_private_info, role_id: role.id)
  |> UserPrivateInfo.changeset(%{email: "testUser@example.com", subscription_type: "basic"})
  |> Repo.insert!()
