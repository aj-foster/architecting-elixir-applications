defmodule Globolive.Persistence.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :globolive,
    adapter: Ecto.Adapters.Postgres
end
