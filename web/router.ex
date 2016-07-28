defmodule Droplet.Router do
  use Droplet.Web, :router

  # pipeline :browser do
  #   plug :accepts, ["html"]
  #   plug :fetch_session
  #   plug :fetch_flash
  #   plug :protect_from_forgery
  #   plug :put_secure_browser_headers
  # end

  pipeline :api do
    plug :accepts, ["json", "json-api"]
    plug JaSerializer.ContentTypeNegotiation # strict content-type/accept enforcement + auto-adding the proper content-type to responses
    plug JaSerializer.Deserializer # Normalize attributes to underscores
  end

  # Unauthenticated routes
  scope "/api/v1", Droplet do
    pipe_through :api # Use the api stack

    # post "/registration", RegistrationController, :create
    # # Route to our SessionController's `create` method (and, within our code, refer to this route as "login")
    # post "/token", SessionController, :create, as: :login

    # get "/user/current", UserController, :index
    # get "/users/:id", UserController, :show
    
  end

  # Authenticated Routes
  scope "/api/v1", Droplet do
    get "/user/current", UserController, :current, as: :current_user
  end




  # Other scopes may use custom stacks.
  # scope "/api", Droplet do
  #   pipe_through :api
  # end
end
