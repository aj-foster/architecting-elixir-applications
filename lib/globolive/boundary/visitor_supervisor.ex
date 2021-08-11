defmodule Globolive.Boundary.VisitorSupervisor do
  @moduledoc """
  Provides a dynamic supervisor for managing visitor session processes.
  """
  use DynamicSupervisor

  alias Globolive.Boundary.VisitorSession

  #
  # Public API
  #

  @doc "Start a dynamic supervisor for visitor session processes."
  @spec start_link(term) :: Supervisor.on_start()
  def start_link(opts) do
    DynamicSupervisor.start_link(__MODULE__, opts, name: Globolive.VisitorSupervisor)
  end

  @doc "Create a new visitor session."
  @spec create_visitor(VisitorSession.visitor_fields()) :: DynamicSupervisor.on_start_child()
  def create_visitor(fields) do
    DynamicSupervisor.start_child(Globolive.VisitorSupervisor, {VisitorSession, fields})
  end

  #
  # Private API
  #

  @doc false
  @impl true
  @spec init(term) :: {:ok, DynamicSupervisor.sup_flags()}
  def init(_opts) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
