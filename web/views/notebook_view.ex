defmodule Droplet.NotebookView do
  use Droplet.Web, :view

  def render("index.json", %{notebooks: notebooks}) do
    %{data: render_many(notebooks, Droplet.NotebookView, "notebook.json")}
  end

  def render("show.json", %{notebook: notebook}) do
    %{data: render_one(notebook, Droplet.NotebookView, "notebook.json")}
  end

  def render("notebook.json", %{notebook: notebook}) do
    %{id: notebook.id,
      title: notebook.title,
      sort_param_code: notebook.sort_param_code,
      owner_id: notebook.owner_id}
  end
end
