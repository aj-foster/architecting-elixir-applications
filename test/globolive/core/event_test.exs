defmodule Globolive.Core.EventTest do
  use ExUnit.Case
  import Globolive.Factory

  alias Globolive.Core.{Attraction, Event}

  describe "new/1" do
    test "creates a new event" do
      attributes = event_fields()
      assert %Event{} = Event.new(attributes)
    end
  end

  describe "add_attraction/2" do
    test "adds a new attraction to an event" do
      event = Event.new(event_fields())
      attributes = attraction_fields()
      assert %Event{attractions: [%Attraction{}]} = Event.add_attraction(event, attributes)
    end

    test "adds additional attractions to an event" do
      event =
        event_with_attraction()
        |> Event.add_attraction(attraction_fields())

      assert %Event{attractions: [%Attraction{}, %Attraction{}]} = event
    end

    test "increments the count of all attractions" do
      event =
        event_with_attraction()
        |> Event.add_attraction(attraction_fields())

      assert %Event{attraction_count: 2} = event
    end
  end

  describe "remove_attraction/2" do
    setup :create_event_with_attraction

    test "removes an attraction from an event", %{event: event, attraction: attraction} do
      assert %Event{attractions: []} = Event.remove_attraction(event, attraction)
    end

    test "decrements the count of all attractions", %{event: event, attraction: attraction} do
      assert %Event{attraction_count: 0} = Event.remove_attraction(event, attraction)
    end
  end

  defp create_event_with_attraction(context) do
    event = event_with_attraction()
    %Event{attractions: [attraction]} = event

    {:ok, Map.merge(context, %{event: event, attraction: attraction})}
  end
end
