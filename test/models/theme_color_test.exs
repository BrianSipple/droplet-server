defmodule Droplet.ThemeColorTest do
  use Droplet.ModelCase

  alias Droplet.ThemeColor

  @valid_attrs %{alpha: "120.5", hue: 42, lightness: 42, saturation: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ThemeColor.changeset(%ThemeColor{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ThemeColor.changeset(%ThemeColor{}, @invalid_attrs)
    refute changeset.valid?
  end
end
