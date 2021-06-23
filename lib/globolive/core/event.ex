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
          attractions: [Attraction.t()],
          attraction_count: non_neg_integer
        }

  @enforce_keys [:name, :start, :finish, :location]
  defstruct name: "",
            start: nil,
            finish: nil,
            location: "",
            attractions: [],
            attraction_count: 0

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
      | attractions: [attraction | event.attractions],
        attraction_count: event.attraction_count + 1
    }
  end

  @doc """
  Remove an attraction, e.g. when a visitor checks in to it.
  """
  @spec remove_attraction(t, Attraction.t()) :: t
  def remove_attraction(event, attraction) do
    attractions = Enum.reject(event.attractions, &(&1 == attraction))
    %__MODULE__{event | attractions: attractions, attraction_count: length(attractions)}
  end
end
