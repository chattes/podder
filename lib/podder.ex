defmodule Podder do
  use GenServer
  require Logger
  alias Elixir.Registry

  @moduledoc """
  Documentation for Podder.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Podder.hello()
      :world

  """
  def init(%{pod_name: name}) do
    new_state = %{pod_name: name}
    schedule_work()
    {:ok, new_state}
  end

  def init(_), do: {:error, "Cannot Initialise Server pod_name is not passed."}

  def handle_call(:fetch, _from, state) do
    new_state = Map.put(state, "fetched", 1)
    {:reply, new_state, new_state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:work, state) do
    # Logger.info("Lets Do some work for #{inspect(state)}")
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work do
    Process.send_after(self(), :work, 5000)
  end

  @doc """
  Client Implementation
  """
  def start_link(%{name: name, state: state}) do
    IO.puts("Start GEN SERVER")
    GenServer.start_link(__MODULE__, state, name: via_tuple(name))
  end

  def fetch_episodes(pid) do
    GenServer.call(pid, :fetch)
  end

  def get_episodes(pid) do
    GenServer.call(pid, :get_state)
  end

  def whereis(name: name), do: Registry.whereis_name({Podder.Registry, name})

  defp via_tuple(name), do: {:via, Registry, {Podder.Registry, name}}
end
