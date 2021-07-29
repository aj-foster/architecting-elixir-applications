defmodule Globolive do
  alias Globolive.Boundary.{EventManager, VisitorSession, VisitorSupervisor}
  alias Globolive.Core.{Attraction, Event, Visitor}

  @spec create_visitor(VisitorSession.visitor_fields()) :: DynamicSupervisor.on_start_child()
  defdelegate create_visitor(fields), to: VisitorSupervisor

  @spec get_visitor(pid | VisitorSession.session_id()) :: Visitor.t()
  defdelegate get_visitor(session), to: VisitorSession

  @spec mark_arrived(pid | VisitorSession.session_id(), DateTime.t() | nil) :: Visitor.t()
  defdelegate mark_arrived(session, timestamp \\ nil), to: VisitorSession

  @spec mark_checkin(pid | VisitorSession.session_id(), Attraction.t()) :: Visitor.t()
  defdelegate mark_checkin(session, attraction), to: VisitorSession

  @spec add_event(GenServer.name(), map) :: :ok
  defdelegate add_event(server \\ EventManager, event_fields), to: EventManager

  @spec add_attraction_to_event(GenServer.name(), String.t(), map) :: Event.t() | nil
  defdelegate add_attraction_to_event(server \\ EventManager, event_name, attraction_fields),
    to: EventManager

  @spec get_event_by_name(GenServer.name(), String.t()) :: Event.t() | nil
  defdelegate get_event_by_name(server \\ EventManager, event_name), to: EventManager
end
