defmodule Droplet.Note do
  use Droplet.Web, :model

  schema "notes" do
    field :title, :string, default: "Untitled"
    field :content, :string
    field :revision_count, :integer, default: 0
    field :priority, :integer, default: 0  # treat "0" as no specific prio

    # 🔑: The difference between `has_one/3` and `belongs_to/3`
    # is that the foreign key is always defined in
    # the schema that invokes `belongs_to/3`
    belongs_to :notebook, Droplet.Notebook
    belongs_to :theme_color, Droplet.ThemeColor

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :revision_count, :priority, :content, :notebook_id, :theme_color_id])
    |> foreign_key_constraint(:notebook_id)
    |> foreign_key_constraint(:theme_color_id)
    |> validate_required([:title, :revision_count, :priority, :notebook_id])
    |> validate_length(:title, max: 255)
    |> validate_inclusion(:priority, 0..10)
  end
end
