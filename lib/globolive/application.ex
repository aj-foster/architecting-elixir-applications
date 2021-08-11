defmodule Globolive.Application do
  @moduledoc """
  Defines a top-level supervisor for our application's processes.
  """
  use Application

  @doc false
  @impl true
  @spec start(term, term) :: {:ok, pid} | {:error, term}
  def start(_type, _args) do
    children = [
      # Persistence
      #
      Globolive.Persistence.Repo,

      # Boundary
      #
      Globolive.Boundary.EventManager,
      {Registry, [keys: :unique, name: Globolive.VisitorRegistry]},
      Globolive.Boundary.VisitorSupervisor,

      # Web
      #
      {Phoenix.PubSub, name: Globolive.Web.PubSub},
      Globolive.Web.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Globolive.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
