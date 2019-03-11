defmodule Podder.PodcastFetcher do
  @expected_fields_podcast ~w(
      description thumbnail next_episode_pub_date
      lastest_pub_date_ms listennotes_url title 
      episodes id total_episodes
  )

  defp add_headers, do: ["X-RapidAPI-Key": Application.get_env(:podder, :api_key)]
  defp process_url(url), do: Application.get_env(:podder, :podcast_base_url) <> url

  def convert_map_keys_to_atoms({k, v}) when is_map(v) do
    {String.to_atom(k), Enum.map(v, &convert_map_keys(&1)) |> Map.new()}
  end

  def convert_map_keys_to_atoms({k, v}) do
    {String.to_atom(k), v}
  end

  defp process_response({:ok, body}) do
    with {:ok, data} <- Poison.decode(body) do
      data
      |> Map.take(@expected_fields_podcast)

      # |> Enum.map(&convert_map_keys_to_atoms(&1))
      # |> Map.new()
    else
      _ ->
        {:error, "Cannot Fetch PodCast Data"}
    end
  end

  defp process_response(_), do: {:error, "Cannot Fetch Podcasts"}

  defp send_request(url, headers) do
    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      {:ok, %HTTPoison.Response{status_code: _}} -> {:error, "Cannot Fetch Podcasts"}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, "Cannot Fetch Podcasts"}
    end
  end

  def fetch_podcast(id) do
    process_url("/podcasts/#{id}?sort=recent_first")
    |> send_request(add_headers())
    |> process_response
  end
end
