import Config

#
# Persistence
#

config :globolive, ecto_repos: [Globolive.Persistence.Repo]

config :globolive, Globolive.Persistence.Repo,
  database: "globolive",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

if Mix.env() == :test do
  config :globolive, Globolive.Persistence.Repo,
    database: "globolive_test",
    pool: Ecto.Adapters.SQL.Sandbox

  config :logger, level: :warn
end

#
# Web
#

config :globolive, Globolive.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "k7/NjQt1pWDiBmvPmR2NUwgFRZK0OhQEsMuT0RwRnCOowVp3no0gYVDRsOTZvC/l",
  render_errors: [view: Globolive.Web.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Globolive.Web.PubSub,
  live_view: [signing_salt: "MmmMYVoa"]

config :phoenix, :json_library, Jason
