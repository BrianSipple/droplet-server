defmodule Droplet.ThemeColor do
  use Droplet.Web, :model

  schema "theme_colors" do
    field :hue, :integer
    field :saturation, :integer
    field :lightness, :integer
    field :alpha, :decimal, default: 1

    # # Given the multitude of possible number combinations,
    # # I'm thinking it's better to just stamp out each color
    # # as a unique item with a foreign key of a note (TODO: Consider reconsidering 😀)
    # belongs_to :note, Droplet.Note
    #
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:hue, :saturation, :lightness, :alpha])
    |> validate_required([:hue, :saturation, :lightness, :alpha])
    |> validate_number(:hue, greater_than_or_equal_to: 0)
    |> validate_number(:hue, less_than_or_equal_to: 360)
    |> validate_number(:saturation, greater_than_or_equal_to: 0)
    |> validate_number(:saturation, less_than_or_equal_to: 100)
    |> validate_number(:lightness, greater_than_or_equal_to: 0)
    |> validate_number(:lightness, less_than_or_equal_to: 100)
    |> validate_number(:alpha, greater_than_or_equal_to: 0)
    |> validate_number(:alpha, less_than_or_equal_to: 1)
  end
end
