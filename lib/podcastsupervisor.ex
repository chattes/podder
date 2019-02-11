defmodule Podder.DynamicSupervisor do
  use DynamicSupervisor

  def start_link() do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Server Side
  """
  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_work do
    {:ok, pid} = start_podcast_server
  end

  defp start_podcast_server do
    spec = %{id: Podder, start: {Podder, :start_link, [%{}]}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
