defmodule Droplet.ErrorViewTest do
  use Droplet.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 401.json" do
    assert render(Droplet.ErrorView, "401.json", []) ==
      %{errors: [%{code: 401, title: "Unauthorized"}]}
  end

  test "renders 403.json" do
    assert render(Droplet.ErrorView, "403.json", []) ==
      %{errors: [%{code: 403, title: "Forbidden"}]}
  end

  test "renders 404.json" do
    assert render(Droplet.ErrorView, "404.json", []) ==
      %{errors: [%{code: 404, title: "Not found"}]}
  end

  test "render 500.json" do
    assert render(Droplet.ErrorView, "500.json", []) ==
      %{errors: [%{code: 500, title: "Internal server error"}]}
  end

  test "render any other" do
    assert render(Droplet.ErrorView, "505.json", []) ==
      %{errors: [%{code: 500, title: "Internal server error"}]}
  end
end
