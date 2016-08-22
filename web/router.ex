defmodule Droplet.Router do
  use Droplet.Web, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  pipeline :api_auth do
    plug :accepts, ["json", "json-api"]
    plug JaSerializer.ContentTypeNegotiation # strict content-type/accept enforcement + auto-adding the proper content-type to responses
    plug JaSerializer.Deserializer # Normalize attributes to underscores
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource # Looks in the `sub` field of the token, fetches the resource from the Serializer and makes it available via `Guardian.Plug.current_resource(conn)`.
  end

  # Unauthenticated routes
  scope "/api/v1", Droplet do
    pipe_through :api # Use the api stack

    # post "/register", RegistrationController, :create

    # # Route to our SessionController's `create` method (and, within our code, refer to this route as "login")
    post "/token", SessionController, :create, as: :login
  end

  # Authenticated Routes
  scope "/api/v1", Droplet do
    pipe_through :api_auth

    get "/user/current", UserController, :current, as: :current_user

    resources "/users", UserController, except: [:new, :edit]

    # TODO: Possible idea
    # resources "/user", UserController, only: [:show, :index] do
    #   get "notebooks", NotebookController, :index, as :notebooks
    # end

    resources "/notebooks", NotebookController, except: [:new, :edit] do
      resources "/notes", NoteController, except: [:new, :edit]
    end

    resources "/theme_colors", ThemeColorController, except: [:new, :edit]
  end
end
