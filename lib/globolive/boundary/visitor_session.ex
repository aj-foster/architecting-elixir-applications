defmodule Globolive.Boundary.VisitorSession do
  @moduledoc """
  Manages the interactions of a single visitor at an event.
  """
  use GenServer

  alias Globolive.Core.{Attraction, Event, Visitor}
  alias Globolive.Persistence

  @type visitor_fields :: {name :: String.t(), email :: String.t(), event :: Event.t()}
  @type state :: Visitor.t()

  @type session_id :: {email :: String.t(), event_name :: String.t()}

  #
  # Public API
  #

  @spec child_spec(visitor_fields) :: Supervisor.child_spec()
  def child_spec({_name, email, event_name} = fields) do
    %{
      id: {__MODULE__, {email, event_name}},
      start: {__MODULE__, :start_link, [fields]},
      restart: :temporary
    }
  end

  @spec start_link(visitor_fields) :: GenServer.on_start()
  def start_link(visitor_fields) do
    GenServer.start_link(__MODULE__, visitor_fields, name: server(visitor_fields))
  end

  @spec get_visitor(pid | session_id) :: Visitor.t()
  def get_visitor(session) do
    server(session)
    |> GenServer.call(:get_visitor)
  end

  @spec mark_arrived(pid | session_id, DateTime.t() | nil) :: Visitor.t()
  def mark_arrived(session, timestamp \\ nil) do
    timestamp = timestamp || DateTime.utc_now()

    server(session)
    |> GenServer.call({:mark_arrived, timestamp})
  end

  @spec mark_checkin(pid | session_id, Attraction.t()) :: Visitor.t() | {:error, term}
  def mark_checkin(session, attraction) do
    server = server(session)

    with visitor <- GenServer.call(server, {:mark_checkin, attraction}),
         {:ok, _checkin} <- Persistence.create_checkin(visitor, attraction) do
      visitor
    end
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

  #
  # Helpers
  #

  @spec server(visitor_fields | session_id | pid) :: GenServer.name()
  defp server(pid) when is_pid(pid), do: pid

  defp server({email, event_name}) do
    {:via, Registry, {Globolive.VisitorRegistry, {email, event_name}}}
  end

  defp server({_name, email, %Event{name: event_name}}) do
    {:via, Registry, {Globolive.VisitorRegistry, {email, event_name}}}
  end
end
