defmodule Droplet.NoteView do
  use Droplet.Web, :view

  def render("index.json", %{notes: notes}) do
    %{data: render_many(notes, Droplet.NoteView, "note.json")}
  end

  def render("show.json", %{note: note}) do
    %{data: render_one(note, Droplet.NoteView, "note.json")}
  end

  def render("note.json", %{note: note}) do
    %{id: note.id,
      title: note.title,
      content: note.content,
      revision_count: note.revision_count,
      priority: note.priority,
      notebook_id: note.notebook_id,
      theme_color_id: note.theme_color_id}
  end
end
