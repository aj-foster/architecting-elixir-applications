defmodule Globolive.Core.Visitor do
  @moduledoc """
  Provides a struct representing an individual's attendance at an event.
  """
  alias Globolive.Core.{Attraction, Event}

  @typedoc """
  An individual attending an event.
  """
  @type t :: %__MODULE__{
          name: String.t(),
          email: String.t(),
          event: Event.t(),
          arrived_at: DateTime.t() | nil,
          visited: MapSet.t(Attraction.t())
        }

  @enforce_keys [:name, :email, :event]
  defstruct name: "",
            email: "",
            event: nil,
            arrived_at: nil,
            visited: MapSet.new()

  @doc """
  Create a new visitor for the given event.
  """
  @spec new(String.t(), String.t(), Event.t()) :: t
  def new(name, email, event) do
    %__MODULE__{
      name: name,
      email: email,
      event: event
    }
  end

  @doc """
  Mark a visitor as checked in at the event.
  """
  @spec mark_arrived(t, DateTime.t()) :: t
  def mark_arrived(visitor, timestamp) do
    %__MODULE__{visitor | arrived_at: timestamp}
  end
end
