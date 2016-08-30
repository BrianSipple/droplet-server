defmodule Droplet.NoteView do
  use Droplet.Web, :view
  use JaSerializer.PhoenixView

  attributes [
    :title,
    :content,
    :revision_count,
    :priority
  ]

end
