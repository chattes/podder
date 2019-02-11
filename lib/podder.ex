defmodule Podder do
  use GenServer

  @moduledoc """
  Documentation for Podder.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Podder.hello()
      :world

  """
  def init(state) do
    {:ok, state}
  end

  def handle_call(:fetch, _from, state) do
    new_state = Map.put(state, "fetched", 1)
    {:reply, new_state, new_state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @doc """
  Client Implementation
  """
  def start_link(state) do
    IO.puts("Start GEN SERVER")
    GenServer.start_link(__MODULE__, state)
  end

  def fetch_episodes(pid) do
    GenServer.call(pid, :fetch)
  end

  def get_episodes(pid) do
    GenServer.call(pid, :get_state)
  end
end
