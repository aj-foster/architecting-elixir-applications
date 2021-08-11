defmodule Globolive.Boundary.VisitorSessionTest do
  use ExUnit.Case
  import Globolive.Factory

  alias Globolive.Boundary.VisitorSession
  alias Globolive.Core.{Attraction, Event, Visitor}

  describe "start_link/1" do
    test "creates a new session" do
      event = event_with_attraction()
      {name, email} = visitor_fields()

      assert {:ok, session} = start_supervised({VisitorSession, {name, email, event}})
      assert %Visitor{event: ^event} = VisitorSession.get_visitor(session)
    end

    test "registers the session process" do
      event = event_with_attraction()
      {name, email} = visitor_fields()

      start_supervised({VisitorSession, {name, email, event}})
      assert assert %Visitor{event: ^event} = VisitorSession.get_visitor({email, event.name})
    end
  end

  describe "get_visitor/1" do
    setup :setup_visitor_fields

    test "gets the session's visitor", %{event: event, visitor_fields: fields} do
      session = start_supervised!({VisitorSession, fields})
      assert %Visitor{event: ^event} = VisitorSession.get_visitor(session)
    end
  end

  describe "mark_arrived/1" do
    setup :setup_visitor_fields

    test "marks a visitor as arrived", %{visitor_fields: fields} do
      session = start_supervised!({VisitorSession, fields})
      visitor = VisitorSession.mark_arrived(session)
      assert Visitor.arrived?(visitor)
    end
  end

  describe "mark_checkin/2" do
    setup :setup_visitor_fields

    test "marks an attraction as visited", %{event: event, visitor_fields: fields} do
      session = start_supervised!({VisitorSession, fields})

      %Event{attractions: [attraction | _]} = event
      attraction_name = Attraction.id(attraction)
      visitor = VisitorSession.mark_checkin(session, attraction_name)

      assert Visitor.visited?(visitor, attraction)
    end
  end

  defp setup_visitor_fields(_context) do
    {name, email} = visitor_fields()
    event = event_with_attraction()

    {:ok, %{event: event, visitor_fields: {name, email, event}}}
  end
end
