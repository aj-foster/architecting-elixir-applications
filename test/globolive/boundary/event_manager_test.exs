defmodule Globolive.Boundary.EventManagerTest do
  use ExUnit.Case
  import Globolive.Factory

  alias Globolive.Boundary.EventManager
  alias Globolive.Core.Event

  describe "start_link/1" do
    test "starts the manager with a custom name" do
      assert {:ok, _pid} = start_supervised({EventManager, [name: EM]})
      refute is_nil(GenServer.whereis(EM))
    end

    test "starts the manager with pre-hydrated events" do
      events = [event_with_attraction(name: "Event1"), event_with_attraction(name: "Event2")]
      assert {:ok, _pid} = start_supervised({EventManager, [events: events, name: EM]})
      assert %Event{} = EventManager.get_event_by_name(EM, "Event1")
      assert %Event{} = EventManager.get_event_by_name(EM, "Event2")
    end
  end

  describe "add_event/2" do
    test "adds an event to the manager" do
      event = event_fields(name: "Event1")
      start_supervised!({EventManager, [name: EM]})
      assert :ok = EventManager.add_event(EM, event)
      assert %Event{} = EventManager.get_event_by_name(EM, "Event1")
    end
  end

  describe "add_attraction_event/3" do
    test "adds an attraction to an existing event" do
      events = [event_with_attraction(name: "Event1")]
      start_supervised!({EventManager, [events: events, name: EM]})
      assert :ok = EventManager.add_attraction_to_event(EM, "Event1", attraction_fields())
      assert %Event{attraction_count: 2} = EventManager.get_event_by_name(EM, "Event1")
    end

    test "returns error for a non-existent event" do
      start_supervised!({EventManager, [name: EM]})
      assert :error = EventManager.add_attraction_to_event(EM, "Fake", attraction_fields())
    end
  end

  describe "get_event_by_name/2" do
    test "returns an event by its name" do
      events = [event_with_attraction(name: "Event1"), event_with_attraction(name: "Event2")]
      start_supervised!({EventManager, [events: events, name: EM]})
      assert %Event{name: "Event1"} = EventManager.get_event_by_name(EM, "Event1")
    end

    test "returns nothing for a non-existent event" do
      events = [event_with_attraction(name: "Event1"), event_with_attraction(name: "Event2")]
      start_supervised!({EventManager, [events: events, name: EM]})
      assert is_nil(EventManager.get_event_by_name(EM, "Non-existent"))
    end
  end
end
