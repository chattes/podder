defmodule Podder.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  use Application
  alias Elixir.Registry

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Podder.Worker.start_link(arg)
      # {Podder.Worker, arg},

      %{
        id: Registry,
        start: {Registry, :start_link, [[keys: :unique, name: Podder.Registry]]}
      },
      %{
        id: Podder.DynamicSupervisor,
        start: {Podder.DynamicSupervisor, :start_link, []}
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
