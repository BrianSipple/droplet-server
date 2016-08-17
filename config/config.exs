# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :droplet,
  ecto_repos: [Droplet.Repo]

# Configures the endpoint
config :droplet, Droplet.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4Gn2FwHFQhU6z2hflpDxHcrRglPe7xxEgXJ2ldxcBurqCqaR7cCWCcwR3muZ0Alm",
  render_errors: [view: Droplet.ErrorView, accepts: ~w(json)],
  pubsub: [name: Droplet.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

  # The JSON-API standard requires that we handle the mime type application/vnd.api+json
  config :phoenix, :format_encoders,
    "json-api": Poison

  config :plug, :mimes, %{
    "application/vnd.api+json" => ["json-api"]
  }

# Guardian config
config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Droplet",
  ttl: { 30, :days },
  verify_issuer: true,  # optional, verifies that the issuer is the same issuer as specified in the `issuer` field
  secret_key: System.get_env("GUARDIAN_SECRET") || "NW7lWEt8MibefHjEuYSBIqoVUQ0FvCtDLjas8v31ISNsViSnfYgzuVZNUK3839IA",
  serializer: Droplet.GuardianSerializer



# Import environment specific config. THIS MUST REMAIN AT THE BOTTOM
# OF THIS FILE so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
