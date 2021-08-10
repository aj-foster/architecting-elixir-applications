import Config

config :globolive, ecto_repos: [Globolive.Persistence.Repo]

config :globolive, Globolive.Persistence.Repo,
  database: "globolive",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
