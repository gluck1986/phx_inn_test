# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :phx, Phx.Repo,
  database: "phx_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"

config :phx,
  ecto_repos: [Phx.Repo]

# Configures the endpoint
config :phx, PhxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wdCni4lIo3S9rhSTj19Z/RXWP2sCMDngj6dB7zeD7gvNr0b+IBOMi9xen4TJbAfI",
  render_errors: [view: PhxWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Phx.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phx, Phx.Users.Guardian,
  issuer: "phx",
  secret_key: Mix.env()

config :phx, Phx.Services.Redis, uri: "redis://localhost:6379"

config :phx, Phx.Services.IpChildren,
  rate: 2000,
  storage_key: "lockedi_ps"

# config :phx, PhxWeb.Gettext, default_locale: "ru", locales: ~w(en ru)

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
