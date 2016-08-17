use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :droplet, Droplet.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger,
  level: :warn,
  backends: [:console]
  # compile_time_purge_level: :info

# Configure your database
config :droplet, Droplet.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "droplet_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# During tests (and tests only), we may want to reduce the number
# of bcrypt rounds so it does not slow down our test suite
config :comeonin, :bcrypt_log_rounds, 4
