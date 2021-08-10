import Config

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
