defmodule Globolive.Boundary.EventManager do
  @moduledoc """
  Manages the listing of all events currently available in the application.
  """
  use GenServer

  alias Globolive.Core.Event

  @type state :: %{(name :: String.t()) => event :: Event.t()}

  #
  # Public API
  #

  @doc """
  Start an Event Manager process.

  ## Options

    * `events`: List of events to hydrate on start-up.
    * `name`: Name of the event manager process.

  """
  @spec start_link(Keyword.t()) :: GenServer.on_start()
  def start_link(opts \\ []) do
    events = opts[:events] || []
    name = opts[:name] || __MODULE__
    GenServer.start_link(__MODULE__, events, name: name)
  end

  @doc "Add an event to the state of the event manager."
  @spec add_event(GenServer.name(), map) :: :ok
  def add_event(server \\ __MODULE__, event_fields) do
    GenServer.call(server, {:add_event, event_fields})
  end

  @doc "Add an attraction to the event with the given name."
  @spec add_attraction_to_event(GenServer.name(), String.t(), map) :: :ok
  def add_attraction_to_event(server \\ __MODULE__, event_name, attraction_fields) do
    GenServer.call(server, {:add_attraction_to_event, event_name, attraction_fields})
  end

  @doc "Get an event by its name."
  @spec get_event_by_name(GenServer.name(), String.t()) :: Event.t()
  def get_event_by_name(server \\ __MODULE__, event_name) do
    GenServer.call(server, {:get_event_by_name, event_name})
  end

  #
  # Private API
  #

  @doc false
  @spec init([Event.t()]) :: {:ok, state} | {:stop, String.t()}
  def init(event_list) do
    if Enum.all?(event_list, fn event -> is_struct(event, Event) end) do
      events =
        Enum.reduce(event_list, %{}, fn event, events ->
          Map.put(events, event.name, event)
        end)

      {:ok, events}
    else
      {:stop, "Pre-seeded events must be given as Event structs"}
    end
  end

  @doc false
  @spec handle_call(term, GenServer.from(), state) :: {:reply, term, state}
  def handle_call(message, from, events)

  def handle_call({:add_event, event_fields}, _from, events) do
    new_event = Event.new(event_fields)
    events = Map.put(events, new_event.name, new_event)
    {:reply, :ok, events}
  end

  def handle_call({:add_attraction_to_event, event_name, attraction_fields}, _from, events) do
    case events[event_name] do
      nil ->
        {:reply, :error, events}

      event ->
        event = Event.add_attraction(event, attraction_fields)
        events = Map.put(events, event_name, event)

        {:reply, :ok, events}
    end
  end

  def handle_call({:get_event_by_name, event_name}, _from, events) do
    {:reply, events[event_name], events}
  end
end
