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
  def log_user(user_name), do: {:ok, pid} = start_user_server(user_name)

  defp start_podcast_server(name) do
    spec = %{
      id: Podder.Podcasts,
      start: {Podder.Podcasts, :start_link, [%{name: name, state: %{pod_name: name}}]}
    }

    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  defp start_user_server(user_name) do
    spec = %{
      id: Podder.User.PodcastPreferences,
      start:
        {Podder.User.PodcastPreferences, :start_link,
         [%{name: user_name, state: %{"user_name" => user_name, "podcasts" => []}}]}
    }

    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
