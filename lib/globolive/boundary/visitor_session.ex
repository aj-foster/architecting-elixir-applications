defmodule Globolive.Boundary.VisitorSession do
  @moduledoc """
  Manages the interactions of a single visitor at an event.
  """
  use GenServer

  alias Globolive.Boundary.EventManager
  alias Globolive.Core.{Attraction, Event, Visitor}

  @type visitor_fields ::
          {name :: String.t(), email :: String.t(),
           (event_name :: String.t()) | (event :: Event.t())}
  @type state :: Visitor.t()

  #
  # Public API
  #

  @spec start_link(visitor_fields) :: GenServer.on_start()
  def start_link(visitor_fields) do
    GenServer.start_link(__MODULE__, visitor_fields, [])
  end

  @spec get_visitor(pid) :: Visitor.t()
  def get_visitor(server) do
    GenServer.call(server, :get_visitor)
  end

  @spec mark_arrived(pid, DateTime.t() | nil) :: Visitor.t()
  def mark_arrived(server, timestamp \\ nil) do
    timestamp = timestamp || DateTime.utc_now()
    GenServer.call(server, {:mark_arrived, timestamp})
  end

  @spec mark_checkin(pid, Attraction.t()) :: Visitor.t()
  def mark_checkin(server, attraction) do
    GenServer.call(server, {:mark_checkin, attraction})
  end

  #
  # Private API
  #

  @doc false
  @spec init(visitor_fields) :: {:ok, state}
  def init({name, email, %Event{} = event}) do
    visitor = Visitor.new(name, email, event)
    {:ok, visitor}
  end

  def init({name, email, event_name}) do
    case EventManager.get_event_by_name(event_name) do
      nil ->
        {:stop, "Event #{event_name} not found"}

      event ->
        init({name, email, event})
    end
  end

  @doc false
  @spec handle_call(term, GenServer.from(), state) :: {:reply, term, state}
  def handle_call(message, from, visitor)

  def handle_call(:get_visitor, _from, visitor) do
    {:reply, visitor, visitor}
  end

  def handle_call({:mark_arrived, timestamp}, _from, visitor) do
    visitor = Visitor.mark_arrived(visitor, timestamp)
    {:reply, visitor, visitor}
  end

  def handle_call({:mark_checkin, attraction}, _from, visitor) do
    visitor = Visitor.mark_checkin(visitor, attraction)
    {:reply, visitor, visitor}
  end
end
