defmodule Droplet.Notebook do
  use Droplet.Web, :model

  schema "notebooks" do
    field :title, :string, default: "Untitled"
    field :sort_param_code, :string, default: "lastUpdatedAtDesc"  # TODO: Make a Ecto type for this Postgres enum (http://stackoverflow.com/questions/35245859/how-to-use-postgres-enumerated-type-with-ecto)

    belongs_to :owner, Droplet.User
    belongs_to :theme_color, Droplet.ThemeColor
    has_many :notes, Droplet.Note

    # TODO: Explore many-to-many relationship for
    # `collaborators` (users) http://stackoverflow.com/a/35684320/3133701

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :sort_param_code, :owner_id, :theme_color_id])
    |> foreign_key_constraint(:owner_id)
    |> foreign_key_constraint(:theme_color_id)
    |> validate_required([:title, :sort_param_code, :owner_id])
    |> validate_length(:title, max: 255)
    |> validate_inclusion(:sort_param_code, ["createdAtDesc", "lastUpdatedAtDesc", "titleAsc", "titleDesc", "collaboratorCountDesc"])
  end
end
