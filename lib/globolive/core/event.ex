defmodule Globolive.Core.Event do
  @moduledoc """
  Provides a struct representing a live event and all of its attractions.
  """
  alias Globolive.Core.Attraction

  @typedoc """
  A live event.
  """
  @type t :: %__MODULE__{
          name: String.t(),
          start: DateTime.t(),
          finish: DateTime.t(),
          location: String.t(),
          attractions: [Attraction.t()]
        }

  @enforce_keys [:name, :start, :finish, :location]
  defstruct name: "",
            start: nil,
            finish: nil,
            location: "",
            attractions: []

  @doc """
  Create a new event with the given attributes.
  """
  @spec new(Enum.t()) :: t
  def new(attributes) do
    struct!(__MODULE__, attributes)
  end

  @doc """
  Add a new attraction with the given attributes to an event.
  """
  @spec add_attraction(t, Enum.t()) :: t
  def add_attraction(event, attraction_attributes) do
    attraction = Attraction.new(attraction_attributes)

    %__MODULE__{
      event
      | attractions: [attraction | event.attractions]
    }
  end
end
