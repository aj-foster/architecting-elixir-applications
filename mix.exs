defmodule Globolive.MixProject do
  use Mix.Project

  def project do
    [
      app: :globolive,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Globolive.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      # Persistence
      #
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},

      # Web
      #
      {:phoenix, "~> 1.5.10"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"}
    ]
  end

  defp aliases do
    [
      test: ["ecto.create", "ecto.migrate", "test"]
    ]
  end
end
