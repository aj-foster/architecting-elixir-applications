defmodule Globolive.Persistence do
  @moduledoc """
  Provides a public API for persisting data to a database.
  """
  import Ecto.Query

  alias Globolive.Core.{Attraction, Visitor}
  alias Globolive.Persistence.{Checkin, Repo}

  @doc """
  List checkins for the given visitor.
  """
  @spec list_checkins(Visitor.t()) :: [Checkin.t()]
  def list_checkins(visitor) do
    {visitor_email, event_name} = Visitor.id(visitor)

    Checkin
    |> where(visitor_email: ^visitor_email, event_name: ^event_name)
    |> order_by(:arrived_at)
    |> Repo.all()
  end

  @doc """
  Record a checkin for the given visitor at the given attraction.
  """
  @spec create_checkin(Visitor.t(), Attraction.t()) :: {:ok, Checkin.t()} | {:error, term}
  def create_checkin(visitor, attraction) do
    {visitor_email, event_name} = Visitor.id(visitor)
    attraction_name = Attraction.id(attraction)

    %{
      visitor_email: visitor_email,
      event_name: event_name,
      attraction_name: attraction_name,
      arrived_at: DateTime.utc_now()
    }
    |> Checkin.changeset()
    |> Repo.insert()
  end
end
