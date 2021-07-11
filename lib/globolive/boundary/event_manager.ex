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

  @spec start_link(term) :: GenServer.on_start()
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @spec add_event(map) :: :ok
  def add_event(event_fields) do
    GenServer.call(__MODULE__, {:add_event, event_fields})
  end

  @spec add_attraction_to_event(String.t(), map) :: :ok
  def add_attraction_to_event(event_name, attraction_fields) do
    GenServer.call(__MODULE__, {:add_attraction_to_event, event_name, attraction_fields})
  end

  @spec get_event_by_name(String.t()) :: Event.t()
  def get_event_by_name(event_name) do
    GenServer.call(__MODULE__, {:get_event_by_name, event_name})
  end

  #
  # Private API
  #

  @spec init(state) :: {:ok, state} | {:stop, String.t()}
  def init(events) do
    if Enum.all?(events, fn {name, event} -> is_binary(name) and is_struct(event, Event) end) do
      {:ok, events}
    else
      {:stop, "Pre-seeded events must be given in %{name => event} form"}
    end
  end

  @spec handle_call(term, GenServer.from(), state) :: {:reply, term, state}
  def handle_call(message, from, events)

  def handle_call({:add_event, event_fields}, _from, events) do
    new_event = Event.new(event_fields)
    events = Map.put(events, new_event.name, new_event)
    {:reply, :ok, events}
  end

  def handle_call({:add_attraction_to_event, event_name, attraction_fields}, _from, events) do
    events =
      Map.update!(events, event_name, fn event ->
        Event.add_attraction(event, attraction_fields)
      end)

    {:reply, :ok, events}
  end

  def handle_call({:get_event_by_name, event_name}, _from, events) do
    {:reply, events[event_name], events}
  end
end
