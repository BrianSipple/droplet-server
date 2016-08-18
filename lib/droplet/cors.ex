defmodule Droplet.CORS do
  # properties here map to Access-Control-X response headers
  use Corsica.Router,
    max_age: 600,
    # origins: ["http://localhost", ~r{^https://(.*\.?).use-droplet\.com$}],  # TODO: More specific settings
    origins: ["*"]
    allow_credentials: true,
    allow_headers: ["user-agent", "accept", "content-type", "authorization"]
end
