defmodule Droplet.TestHelper do
  alias Droplet.Repo
  alias Droplet.Role
  alias Droplet.User
  alias Droplet.UserPrivateInfo
  alias Droplet.ThemeColor
  alias Droplet.Notebook
  alias Droplet.Note

  import Ecto, only: [build_assoc: 3]

  @default_role_attrs %{name: "owner", admin: true}
  @default_user_attrs %{first_name: "Brian", last_name: "Sipple", username: "bsipple", password: "Google123", password_confirmation: "Google123"}
  @default_user_private_info_attrs %{email: "bsipple@test.com", subscription_type: "basic"}
  @default_theme_color_attrs %{hue: 42, saturation: 100, lightness: 88, alpha: Decimal.new(0.9)}
  @default_notebook_attrs %{title: "Colors", sort_param_code: "lastUpdatedAtDesc"}
  @default_note_attrs %{title: "Colors", content: "I like blue", revision_count: 42, priority: 1}

  def create_role(opts \\ %{}) do
    Role.changeset(%Role{}, merge_defaults(@default_role_attrs, opts))
    |> Repo.insert
  end
  # def create_role(%{name: name, admin: admin}) do
  #   Role.changeset(%Role{}, %{name: name, admin: admin})
  #   |> Repo.insert
  # end

  def create_user(opts \\ %{}) do
    User.changeset(%User{}, merge_defaults(@default_user_attrs, opts))
    |> Repo.insert()
  end
  # def create_user(%{first_name: first_name, last_name: last_name, username: username,
  # password: password, password_confirmation: password_confirmation}) do
  #   User.changeset(%User{}, %{
  #     first_name: first_name,
  #     last_name: last_name,
  #     username: username,
  #     password: password,
  #     password_confirmation: password_confirmation
  #   })
  #   |> Repo.insert()
  # end

  def create_user_private_info(user, role, opts \\ %{}) do
    user
    |> build_assoc(:user_private_infos, role_id: role.id)
    |> UserPrivateInfo.changeset(merge_defaults(@default_user_private_info_attrs, opts))
    |> Repo.insert()
  end
  # def create_user_private_info(user, role, %{email: email,
  # subscription_type: subscription_type}) do
  #   user
  #   |> build_assoc(:user_private_infos, role_id: role.id)
  #   |> UserPrivateInfo.changeset(%{email: email, subscription_type: subscription_type})
  #   |> Repo.insert()
  # end

  def create_theme_color(opts \\ %{}) do
    ThemeColor.changeset(%ThemeColor{}, merge_defaults(@default_theme_color_attrs, opts))
    |> Repo.insert()
  end
  # def create_theme_color(%{hue: hue, saturation: saturation, lightness: lightness, alpha: alpha}) do
  #   ThemeColor.changeset(%ThemeColor{}, %{hue: hue, saturation: saturation, lightness: lightness, alpha: alpha})
  #   |> Repo.insert()
  # end


  def create_notebook(user, theme_color, opts \\ %{}) do
    user
    |> build_assoc(:notebooks, owner_id: user.id, theme_color_id: theme_color.id)
    |> Notebook.changeset(merge_defaults(@default_notebook_attrs, opts))
    |> Repo.insert()
  end

  def create_note(notebook, theme_color, opts \\ %{}) do
    notebook
    |> build_assoc(:notes, notebook_id: notebook.id, theme_color_id: theme_color.id)
    |> Note.changeset(merge_defaults(@default_note_attrs, opts))
    |> Repo.insert()
  end

  # Merge options into a "source" of defaults, using the default for each
  # key if the inBound object contains `_nil` for it
  defp merge_defaults(source, inBound) do
    Map.merge(source, inBound, fn _key, default, val -> val || default end)
  end

end
