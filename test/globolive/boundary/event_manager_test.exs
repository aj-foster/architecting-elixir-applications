defmodule Globolive.Boundary.EventManagerTest do
  use ExUnit.Case
  import Globolive.Factory

  alias Globolive.Boundary.EventManager
  alias Globolive.Core.Event

  describe "start_link/1" do
    test "starts the manager with no events and a default name" do
      assert {:ok, _pid} = start_supervised(EventManager)
      refute is_nil(GenServer.whereis(EventManager))
    end

    test "starts the manager with a custom name" do
      assert {:ok, _pid} = start_supervised({EventManager, [name: Globolive.Test.EventManager]})
      refute is_nil(GenServer.whereis(Globolive.Test.EventManager))
    end

    test "starts the manager with pre-hydrated events" do
      events = [event_with_attraction(name: "Event1"), event_with_attraction(name: "Event2")]
      assert {:ok, _pid} = start_supervised({EventManager, [events: events]})
      assert %Event{} = EventManager.get_event_by_name("Event1")
      assert %Event{} = EventManager.get_event_by_name("Event2")
    end
  end

  describe "add_event/2" do
    test "adds an event to the manager" do
      event = event_fields(name: "Event1")
      start_supervised!(EventManager)
      assert :ok = EventManager.add_event(event)
      assert %Event{} = EventManager.get_event_by_name("Event1")
    end
  end

  describe "add_attraction_event/3" do
    test "adds an attraction to an existing event" do
      events = [event_with_attraction(name: "Event1")]
      start_supervised!({EventManager, [events: events]})
      assert :ok = EventManager.add_attraction_to_event("Event1", attraction_fields())
      assert %Event{attraction_count: 2} = EventManager.get_event_by_name("Event1")
    end

    test "returns error for a non-existent event" do
      start_supervised!(EventManager)
      assert :error = EventManager.add_attraction_to_event("Non-existent", attraction_fields())
    end
  end

  describe "get_event_by_name/2" do
    test "returns an event by its name" do
      events = [event_with_attraction(name: "Event1"), event_with_attraction(name: "Event2")]
      start_supervised!({EventManager, [events: events]})
      assert %Event{name: "Event1"} = EventManager.get_event_by_name("Event1")
    end

    test "returns nothing for a non-existent event" do
      events = [event_with_attraction(name: "Event1"), event_with_attraction(name: "Event2")]
      start_supervised!({EventManager, [events: events]})
      assert is_nil(EventManager.get_event_by_name("Non-existent"))
    end
  end
end
