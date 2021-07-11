defmodule Globolive.Boundary.EventManagerTest do
  use ExUnit.Case
  import Globolive.Factory

  alias Globolive.Boundary.EventManager
  alias Globolive.Core.Event

  describe "start_link/1" do
    test "starts the manager with no events and a default name" do
      assert {:ok, _pid} = EventManager.start_link()
      refute is_nil(GenServer.whereis(EventManager))
    end

    test "starts the manager with a custom name" do
      assert {:ok, _pid} = EventManager.start_link(name: Globolive.Test.EventManager)
      refute is_nil(GenServer.whereis(Globolive.Test.EventManager))
    end

    test "starts the manager with pre-hydrated events" do
      events = [event_with_attraction(name: "Event1"), event_with_attraction(name: "Event2")]
      assert {:ok, _pid} = EventManager.start_link(events: events)
      assert %Event{} = EventManager.get_event_by_name("Event1")
      assert %Event{} = EventManager.get_event_by_name("Event2")
    end
  end

  describe "add_event/2" do
    test "adds an event to the manager" do
      event = event_fields(name: "Event1")
      EventManager.start_link()
      assert :ok = EventManager.add_event(event)
      assert %Event{} = EventManager.get_event_by_name("Event1")
    end
  end
end
