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
end
