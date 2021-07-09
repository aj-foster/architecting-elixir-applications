defmodule Globolive.Core.Attraction do
  @moduledoc """
  Provides a struct representing an attraction (booth, activity, etc.) at a live event.
  """

  @typedoc """
  An attraction (booth, activity, etc.) at a live event.
  """
  @type t :: %__MODULE__{
          name: String.t(),
          start: DateTime.t(),
          finish: DateTime.t(),
          location: String.t()
        }

  @enforce_keys [:name, :start, :finish, :location]
  defstruct [:name, :start, :finish, :location]

  @doc """
  Create a new attraction with the given attributes.
  """
  @spec new(Enum.t()) :: t
  def new(attributes) do
    struct!(__MODULE__, attributes)
  end
end
