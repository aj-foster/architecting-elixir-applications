defmodule Globolive.Persistence.Repo.Migrations.CreateCheckins do
  use Ecto.Migration

  def change do
    create table(:checkins) do
      add :visitor_email, :text, null: false
      add :event_name, :text, null: false
      add :attraction_name, :text, null: false
      add :arrived_at, :utc_datetime_usec, null: false
    end
  end
end
