defmodule Droplet.ErrorView do
  use Droplet.Web, :view
  use JaSerializer.PhoenixView

  # Why is the title "Unauthorized" when this is rendered for "Unauthenticated" errors?
  # see: http://stackoverflow.com/questions/3297048/403-forbidden-vs-401-unauthorized-http-responses
  def render("401.json", _assigns) do
    %{title: "Unauthorized", code: 401}
    |> JaSerializer.ErrorSerializer.format
  end

  # Handles actual "unauthorized" errors (401s are for "unauthenticated")
  # I.E: "The authenticated user is not authorized to view this page"
  def render("403.json", _assigns) do
    %{title: "Forbidden", code: 403}
    |> JaSerializer.ErrorSerializer.format
  end


  def render("404.json", _assigns) do
    %{title: "Not found", code: 404}
    |> JaSerializer.ErrorSerializer.format
  end

  def render("500.json", _assigns) do
    %{title: "Internal server error", code: 500}
    |> JaSerializer.ErrorSerializer.format
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, _assigns) do
    %{title: "Internal server error", code: 500}
    |> JaSerializer.ErrorSerializer.format  end
end
