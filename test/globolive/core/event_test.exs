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
        Event.new(event_fields())
        |> Event.add_attraction(attraction_fields())
        |> Event.add_attraction(attraction_fields())

      assert %Event{attractions: [%Attraction{}, %Attraction{}]} = event
    end

    test "increments the count of all attractions" do
      event =
        Event.new(event_fields())
        |> Event.add_attraction(attraction_fields())
        |> Event.add_attraction(attraction_fields())

      assert %Event{attraction_count: 2} = event
    end
  end
end
