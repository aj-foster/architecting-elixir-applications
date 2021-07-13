defmodule Globolive.Boundary.EventManagerETSTest do
  use ExUnit.Case
  import Globolive.Factory

  alias Globolive.Boundary.EventManagerETS
  alias Globolive.Core.Event

  describe "start_link/1" do
    test "starts the manager with no events and a default name" do
      assert {:ok, _pid} = EventManagerETS.start_link()
      refute is_nil(GenServer.whereis(EventManagerETS))
    end

    test "starts the manager with pre-hydrated events" do
      events = [event_with_attraction(name: "Event1"), event_with_attraction(name: "Event2")]
      assert {:ok, _pid} = EventManagerETS.start_link(events: events)
      assert %Event{} = EventManagerETS.get_event_by_name("Event1")
      assert %Event{} = EventManagerETS.get_event_by_name("Event2")
    end
  end

  describe "add_event/2" do
    test "adds an event to the manager" do
      event = event_fields(name: "Event1")
      EventManagerETS.start_link()
      assert :ok = EventManagerETS.add_event(event)
      assert %Event{} = EventManagerETS.get_event_by_name("Event1")
    end
  end

  describe "add_attraction_event/3" do
    test "adds an attraction to an existing event" do
      events = [event_with_attraction(name: "Event1")]
      EventManagerETS.start_link(events: events)
      assert :ok = EventManagerETS.add_attraction_to_event("Event1", attraction_fields())
      assert %Event{attraction_count: 2} = EventManagerETS.get_event_by_name("Event1")
    end

    test "returns error for a non-existent event" do
      EventManagerETS.start_link()
      assert :error = EventManagerETS.add_attraction_to_event("Non-existent", attraction_fields())
    end
  end

  describe "get_event_by_name/2" do
    test "returns an event by its name" do
      events = [event_with_attraction(name: "Event1"), event_with_attraction(name: "Event2")]
      EventManagerETS.start_link(events: events)
      assert %Event{name: "Event1"} = EventManagerETS.get_event_by_name("Event1")
    end

    test "returns nothing for a non-existent event" do
      events = [event_with_attraction(name: "Event1"), event_with_attraction(name: "Event2")]
      EventManagerETS.start_link(events: events)
      assert is_nil(EventManagerETS.get_event_by_name("Non-existent"))
    end
  end
end
