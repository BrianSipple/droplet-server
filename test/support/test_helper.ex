defmodule Droplet.TestHelper do
  alias Droplet.Repo
  alias Droplet.Role
  alias Droplet.User
  alias Droplet.UserPrivateInfo
  alias Droplet.ThemeColor
  alias Droplet.Notebook

  import Ecto, only: [build_assoc: 3]

  def create_role(%{name: name, admin: admin}) do
    Role.changeset(%Role{}, %{name: name, admin: admin})
    |> Repo.insert
  end

  def create_user(%{first_name: first_name, last_name: last_name, username: username,
  password: password, password_confirmation: password_confirmation}) do
    User.changeset(%User{}, %{
      first_name: first_name,
      last_name: last_name,
      username: username,
      password: password,
      password_confirmation: password_confirmation
    })
    |> Repo.insert()
  end

  def create_user_private_info(user, role, %{email: email,
  subscription_type: subscription_type}) do
    user
    |> build_assoc(:user_private_infos, role_id: role.id)
    |> UserPrivateInfo.changeset(%{email: email, subscription_type: subscription_type})
    |> Repo.insert()
  end

  def create_theme_color(%{hue: hue, saturation: saturation, lightness: lightness, alpha: alpha}) do
    ThemeColor.changeset(%ThemeColor{}, %{hue: hue, saturation: saturation, lightness: lightness, alpha: alpha})
    |> Repo.insert()
  end


  def create_notebook(user, theme_color, %{title: title}) do
    user
    |> build_assoc(:notebooks, owner_id: user.id, theme_color_id: theme_color.id)
    |> Notebook.changeset(%{title: title})
    |> Repo.insert()
  end

end
