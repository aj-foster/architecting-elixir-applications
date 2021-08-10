defmodule Globolive.Persistence.Checkin do
  @moduledoc """
  Provides a checkin schema for recording visitor checkin events.
  """
  use Ecto.Schema

  alias Ecto.Changeset

  @fields [:visitor_email, :event_name, :attraction_name, :arrived_at]

  @type t :: %__MODULE__{
          visitor_email: String.t(),
          event_name: String.t(),
          attraction_name: String.t(),
          arrived_at: DateTime.t()
        }

  schema "checkins" do
    field :visitor_email, :string
    field :event_name, :string
    field :attraction_name, :string
    field :arrived_at, :utc_datetime_usec
  end

  @doc false
  @spec changeset(map) :: Changeset.t(t)
  def changeset(attributes) do
    %__MODULE__{}
    |> Changeset.cast(attributes, @fields)
    |> Changeset.validate_required(@fields)
  end
end
