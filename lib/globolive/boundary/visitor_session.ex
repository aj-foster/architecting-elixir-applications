defmodule Globolive.Boundary.VisitorSession do
  @moduledoc """
  Manages the interactions of a single visitor at an event.
  """
  use GenServer

  alias Globolive.Core.{Event, Visitor}
  alias Globolive.Persistence

  @type visitor_fields :: {name :: String.t(), email :: String.t(), event :: Event.t()}
  @type state :: Visitor.t()

  @type session_id :: pid | {email :: String.t(), event_name :: String.t()}

  #
  # Public API
  #

  @doc false
  @spec child_spec(visitor_fields) :: Supervisor.child_spec()
  def child_spec({_name, email, event_name} = fields) do
    %{
      id: {__MODULE__, {email, event_name}},
      start: {__MODULE__, :start_link, [fields]},
      restart: :temporary
    }
  end

  @doc "Start a Visitor Session process."
  @spec start_link(visitor_fields) :: GenServer.on_start()
  def start_link(visitor_fields) do
    GenServer.start_link(__MODULE__, visitor_fields, name: server(visitor_fields))
  end

  @doc "Get a Visitor struct from the session."
  @spec get_visitor(session_id) :: Visitor.t()
  def get_visitor(session) do
    server(session)
    |> GenServer.call(:get_visitor)
  end

  @doc "Mark the visitor as arrived at the event."
  @spec mark_arrived(session_id, DateTime.t() | nil) :: Visitor.t()
  def mark_arrived(session, timestamp \\ nil) do
    timestamp = timestamp || DateTime.utc_now()

    server(session)
    |> GenServer.call({:mark_arrived, timestamp})
  end

  @doc "Check in the visitor at the given attraction."
  @spec mark_checkin(session_id, String.t()) :: Visitor.t() | {:error, term}
  def mark_checkin(session, attraction_name) do
    server = server(session)

    with visitor <- GenServer.call(server, {:mark_checkin, attraction_name}),
         {:ok, _checkin} <- Persistence.create_checkin(visitor, attraction_name) do
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

  def handle_call({:mark_checkin, attraction_name}, _from, visitor) do
    attraction =
      visitor
      |> Visitor.get_event()
      |> Event.get_attraction(attraction_name)

    if is_nil(attraction) do
      {:reply, visitor, visitor}
    else
      visitor = Visitor.mark_checkin(visitor, attraction)
      {:reply, visitor, visitor}
    end
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
