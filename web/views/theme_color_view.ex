defmodule Droplet.ThemeColorView do
  use Droplet.Web, :view

  def render("index.json", %{theme_colors: theme_colors}) do
    %{data: render_many(theme_colors, Droplet.ThemeColorView, "theme_color.json")}
  end

  def render("show.json", %{theme_color: theme_color}) do
    %{data: render_one(theme_color, Droplet.ThemeColorView, "theme_color.json")}
  end

  def render("theme_color.json", %{theme_color: theme_color}) do
    %{id: theme_color.id,
      hue: theme_color.hue,
      saturation: theme_color.saturation,
      lightness: theme_color.lightness,
      alpha: theme_color.alpha}
  end
end
