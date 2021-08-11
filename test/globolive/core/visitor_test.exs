defmodule Globolive.Core.VisitorTest do
  use ExUnit.Case
  import Globolive.Factory

  alias Globolive.Core.{Attraction, Event, Visitor}

  describe "new/3" do
    test "creates a new visitor" do
      {name, email} = visitor_fields()
      event = event_with_attraction()

      assert %Visitor{name: ^name, email: ^email, event: %Event{}} =
               Visitor.new(name, email, event)
    end
  end

  describe "arrived?/1" do
    setup :setup_visitor_with_event

    test "returns true when a visitor has arrived", %{visitor: visitor} do
      visitor = Visitor.mark_arrived(visitor, DateTime.utc_now())
      assert Visitor.arrived?(visitor)
    end

    test "returns false when a visitor has not arrived", %{visitor: visitor} do
      refute Visitor.arrived?(visitor)
    end
  end

  describe "get_event/1" do
    setup :setup_visitor_with_event

    test "returns the associated event", %{event: event, visitor: visitor} do
      assert event == Visitor.get_event(visitor)
    end
  end

  describe "mark_arrived/2" do
    setup :setup_visitor_with_event

    test "adds an arrival time", %{visitor: visitor} do
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

  describe "visited?/2" do
    setup :setup_visitor_with_event

    test "returns true for a visited attraction", %{event: event, visitor: visitor} do
      %Event{attractions: [attraction | _]} = event
      visitor = Visitor.mark_checkin(visitor, attraction)
      assert Visitor.visited?(visitor, attraction)
    end

    test "returns false for an unvisited attraction", %{event: event, visitor: visitor} do
      %Event{attractions: [attraction | _]} = event
      refute Visitor.visited?(visitor, attraction)
    end
  end

  defp setup_visitor_with_event(_context) do
    {name, email} = visitor_fields()
    event = event_with_attraction()
    visitor = Visitor.new(name, email, event)

    {:ok, %{event: event, visitor: visitor}}
  end
end
