defmodule Globolive.Factory do
  @moduledoc """
  Provides helpers for creating testing data.
  """

  @doc """
  Creates a map containing the fields necessary to build a valid Attraction struct.
  """
  @spec attraction_fields(map) :: map
  def attraction_fields(attributes \\ %{}) do
    %{
      name: "Attraction #{random_number()}",
      start: DateTime.utc_now(),
      finish: DateTime.utc_now() |> DateTime.add(3600, :second),
      location: "Some Venue"
    }
    |> Map.merge(attributes)
  end

  # Provides a random number between 1 and 1,000.
  @spec random_number :: integer
  defp random_number do
    :rand.uniform(1_000)
  end
end
