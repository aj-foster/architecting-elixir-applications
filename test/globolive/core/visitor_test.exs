defmodule Globolive.Core.VisitorTest do
  use ExUnit.Case
  import Globolive.Factory

  alias Globolive.Core.{Attraction, Event, Visitor}

  describe "new/3" do
    test "creates a new visitor" do
      {name, email} = visitor_fields()
      event = Event.new(event_fields())

      assert %Visitor{name: ^name, email: ^email, event: %Event{}} =
               Visitor.new(name, email, event)
    end
  end

  describe "mark_arrived/2" do
    test "adds an arrival time" do
      {name, email} = visitor_fields()
      event = Event.new(event_fields())

      visitor = Visitor.new(name, email, event)
      timestamp = DateTime.utc_now()

      assert %Visitor{arrived_at: ^timestamp} = Visitor.mark_arrived(visitor, timestamp)
    end
  end

  describe "mark_checkin/2" do
    test "adds the attraction to the visited set" do
      attraction_attributes = attraction_fields()
      attraction = Attraction.new(attraction_attributes)

      event =
        Event.new(event_fields())
        |> Event.add_attraction(attraction_attributes)

      {name, email} = visitor_fields()
      visitor = Visitor.new(name, email, event)

      assert %Visitor{visited: visited} = Visitor.mark_checkin(visitor, attraction)
      assert MapSet.to_list(visited) == [attraction]
    end

    test "removes the attraction from the available list" do
      attraction_attributes = attraction_fields()
      attraction = Attraction.new(attraction_attributes)

      event =
        Event.new(event_fields())
        |> Event.add_attraction(attraction_attributes)

      {name, email} = visitor_fields()
      visitor = Visitor.new(name, email, event)

      assert %Visitor{event: event} = Visitor.mark_checkin(visitor, attraction)
      assert length(event.attractions) == 0
    end
  end
end
