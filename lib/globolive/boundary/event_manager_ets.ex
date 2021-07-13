defmodule Globolive.Boundary.EventManagerETS do
  @moduledoc """
  Manages the listing of all events currently available in the application using an ETS table
  for demonstration purposes. In addition to the table, this GenServer will maintain a count of
  all available events.
  """
  use GenServer

  alias Globolive.Core.Event

  @type state :: non_neg_integer

  #
  # Public API
  #

  @doc """
  Start an Event Manager process.

  ## Options

    * `events`: List of events to hydrate on start-up.

  """
  @spec start_link(Keyword.t()) :: GenServer.on_start()
  def start_link(opts \\ []) do
    events = opts[:events] || []
    GenServer.start_link(__MODULE__, events, name: __MODULE__)
  end

  @doc "Add an event to the state of the event manager."
  @spec add_event(map) :: :ok
  def add_event(event_fields) do
    GenServer.call(__MODULE__, {:add_event, event_fields})
  end

  @doc "Add an attraction to the event with the given name."
  @spec add_attraction_to_event(String.t(), map) :: :ok
  def add_attraction_to_event(event_name, attraction_fields) do
    GenServer.call(__MODULE__, {:add_attraction_to_event, event_name, attraction_fields})
  end

  @doc "Get an event by its name."
  @spec get_event_by_name(String.t()) :: Event.t()
  def get_event_by_name(event_name) do
    case :ets.lookup(__MODULE__, event_name) do
      [] -> nil
      [{^event_name, event}] -> event
    end
  end

  #
  # Private API
  #

  @doc false
  @spec init([Event.t()]) :: {:ok, state} | {:stop, String.t()}
  def init(event_list) do
    :ets.new(__MODULE__, [:set, :protected, :named_table])

    if Enum.all?(event_list, fn event -> is_struct(event, Event) end) do
      Enum.each(event_list, fn event ->
        :ets.insert(__MODULE__, {event.name, event})
      end)

      {:ok, length(event_list)}
    else
      {:stop, "Pre-seeded events must be given as Event structs"}
    end
  end

  @doc false
  @spec handle_call(term, GenServer.from(), state) :: {:reply, term, state}
  def handle_call(message, from, count)

  def handle_call({:add_event, event_fields}, _from, count) do
    new_event = Event.new(event_fields)
    :ets.insert(__MODULE__, {new_event.name, new_event})
    {:reply, :ok, count + 1}
  end

  def handle_call({:add_attraction_to_event, event_name, attraction_fields}, _from, count) do
    case :ets.lookup(__MODULE__, event_name) do
      [] ->
        {:reply, :error, count}

      [{^event_name, event}] ->
        event = Event.add_attraction(event, attraction_fields)
        :ets.insert(__MODULE__, {event.name, event})

        {:reply, :ok, count}
    end
  end
end
