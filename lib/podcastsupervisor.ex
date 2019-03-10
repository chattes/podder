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

  def start_work(name), do: {:ok, pid} = start_podcast_server(name)

  defp start_podcast_server(name) do
    spec = %{id: Podder, start: {Podder, :start_link, [%{name: name, state: %{pod_name: name}}]}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
