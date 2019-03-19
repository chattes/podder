defmodule Podder.User.PodcastPreferences do
  use GenServer
  require Logger
  alias Elixir.Registry

  @fields_podcasts ~w(id thumbnail title_original)

  @moduledoc """
  > Searches for Podcasts By name
  > User Selects Podcasts they want
  > Stores the Users Podcasts in GenServer State
  """
  def init(state) do
    {:ok, state}
  end

  def handle_cast({:save, items}, state) do
    my_items =
      cond do
        is_list(items) -> items
        true -> [items]
      end

    new_pods = Map.get(state, "podcasts") |> Enum.concat(my_items)
    new_state = Map.put(state, "podcasts", new_pods)
    {:noreply, new_state}
    # {:noreply, %{state | "podcasts" => new_pods}}
  end

  def handle_call({:search, query}, from, state) do
    response =
      with {:ok, result} <- Podder.ListenProvider.API.search_podcasts(query) do
        result
        |> Map.get("podcasts")
        |> Enum.map(fn x -> Map.take(x, @fields_podcasts) end)
      else
        _ -> %{}
      end

    {:reply, response, state}
  end

  def handle_call(:get_preferences, _from, state) do
    {:reply, state, state}
  end

  @doc """
  Client Implementation
  """
  def start_link(%{name: user_name, state: state}) do
    IO.puts("Start Podder Preferences GEN SERVER for #{user_name}")
    GenServer.start_link(__MODULE__, state, name: via_tuple(user_name))
  end

  def search_podcasts(pid, query) do
    GenServer.call(pid, {:search, query})
  end

  def save_podcasts(pid, items) do
    GenServer.cast(pid, {:save, items})
  end

  def get_preferences(pid) do
    GenServer.call(pid, :get_preferences)
  end

  def whereis(name: name), do: Registry.whereis_name({Podder.Registry, name})
  defp via_tuple(name), do: {:via, Registry, {Podder.Registry, name}}
end
