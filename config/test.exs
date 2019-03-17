use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phx, PhxWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :phx, Phx.Repo,
  username: "phx",
  password: "phx",
  database: "phx_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :phx, Phx.Users.Guardian,
  issuer: "phx",
  secret_key: "GvnjBlTbbjZm6HoUQklSXAsLb7xFBNaPlTfQ/EGoI9jFk7E3E1XqiQDOIlYL3Vm1"

config :phx, Phx.Services.Redis,
  host: "localhost",
  port: 6379

config :phx, Phx.Services.IpChildren,
  rate: 500,
  storage_key: "test_lockedi_ps"
