defmodule Globolive.Persistence.Repo do
  use Ecto.Repo,
    otp_app: :globolive,
    adapter: Ecto.Adapters.Postgres
end
