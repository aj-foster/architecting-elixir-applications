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
    |> Map.merge(to_map(attributes))
  end

  @doc """
  Creates a map containing the fields necessary to build a valid Event struct.
  """
  @spec event_fields(map) :: map
  def event_fields(attributes \\ %{}) do
    %{
      name: "Event #{random_number()}",
      start: DateTime.utc_now(),
      finish: DateTime.utc_now() |> DateTime.add(7200, :second),
      location: "Some Venue"
    }
    |> Map.merge(to_map(attributes))
  end

  @doc """
  Creates a fake name and email combination.
  """
  @spec visitor_fields :: {name :: String.t(), email :: String.t()}
  def visitor_fields do
    random = random_number()
    name = "Person #{random}"
    email = "person-#{random}@example.com"

    {name, email}
  end

  # Provides a random number between 1 and 1,000.
  @spec random_number :: integer
  defp random_number do
    :rand.uniform(1_000)
  end

  # Ensures incoming attributes are in map form.
  @spec to_map(Enum.t()) :: map
  defp to_map(%{} = attributes), do: attributes
  defp to_map(attributes), do: Map.new(attributes)
end
