defmodule Droplet.Router do
  use Droplet.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  scope "/", Droplet do
    # pipe_through :browser # Use the default browser stack
    pipe_through :api # Use the default browser stack

    get "/users", UserController, :index
    get "/users/:id", UserController, :show

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Droplet do
  #   pipe_through :api
  # end
end
