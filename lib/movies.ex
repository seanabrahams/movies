defmodule Movies do
  use HTTPoison.Base

  # TODO: Update @tmdb_genres upon startup and periodically so it doesn't get
  # stale and require manual updates
  @tmdb_genres %{
    28 => "Action",
    12 => "Adventure",
    16 => "Animation",
    35 => "Comedy",
    80 => "Crime",
    99 => "Documentary",
    18 => "Drama",
    10751 => "Family",
    14 => "Fantasy",
    10769 => "Foreign",
    36 => "History",
    27 => "Horror",
    10402 => "Music",
    9648 => "Mystery",
    10749 => "Romance",
    878 => "Science Fiction",
    10770 => "TV Movie",
    53 => "Thriller",
    10752 => "War",
    37 => "Western"
  }

  def configuration do
    get!("configuration?").body
  end

  def find(tmdb_id: id) do
    get!("movie/#{id}?append_to_response=trailers").body
  end

  def genres do
    get!("genre/movie/list?").body
  end

  def images(movie) do
    get!("movie/#{movie.tmdb_id}/images?").body
  end

  def latest(params \\ %{}) do
    get!("movie/latest?#{URI.encode_query(params)}&append_to_response=videos").body
  end

  def now_playing(params \\ %{}) do
    get!("movie/now_playing?#{URI.encode_query(params)}&append_to_response=videos").body
  end

  def popular(params \\ %{}) do
    get!("movie/popular?#{URI.encode_query(params)}&append_to_response=videos").body
  end

  def search(query, params \\ %{}) do
    params = Map.merge(params, %{"query" => query})
    get!("search/movie?#{URI.encode_query(params)}&append_to_response=videos").body
  end

  def similar(movie, params \\ %{}) do
    get!("movie/#{movie.tmdb_id}/similar?#{URI.encode_query(params)}&append_to_response=videos").body
  end

  def top(params \\ %{}) do
    get!("movie/top_rated?#{URI.encode_query(params)}&append_to_response=videos").body
  end

  def upcoming(params \\ %{}) do
    get!("movie/upcoming?#{URI.encode_query(params)}&append_to_response=videos").body
  end

  def videos(movie) do
    get!("movie/#{movie.tmdb_id}/videos?").body
  end

  # Example response:
  #
  # %HTTPoison.Response{
  #   headers: [
  #     {"Access-Control-Allow-Origin", "*"},
  #     {"Cache-Control", "public, max-age=21600"},
  #     {"Content-Type", "application/json;charset=utf-8"},
  #     {"Date", "Tue, 17 May 2016 20:02:58 GMT"},
  #     {"ETag", "9fe8593a8a330607d76796b35c64c600"},
  #     {"Server", "openresty"},
  #     {"X-RateLimit-Limit", "40"},
  #     {"X-RateLimit-Remaining", "39"},
  #     {"X-RateLimit-Reset", "1463515388"},
  #     {"Content-Length", "678"},
  #     {"Connection", "keep-alive"}
  #   ],
  #   status_code: 200,
  #   body: %{
  #   "page" => 1,
  #   "results" => [ ... Movies ... ]
  #   "total_pages" => 985,
  #   "total_results" => 19684
  #   }
  # }
  defp process_response_body(body) do
    body
    |> Poison.decode!
    |> to_struct
  end

  defp process_url(url) do
    api_key = Application.fetch_env!(:movies, :tmdb_api_key)
    "https://api.themoviedb.org/3/" <> url <> "&api_key=#{api_key}"
  end

  defp to_struct(data) do
    case data do
      %{"results" => results} -> Map.put(data, "results", convert(data["results"]))
      _ -> convert(data)
    end
  end

  defp convert(data) when is_list(data) do
    Enum.map(data, &(convert(&1)))
  end

  # TODO: Re-engineer this so that it will accurately process each type of
  # result. Relying on pattern matching on arbitrary fields such as type and
  # title will not be sufficient.
  defp convert(data) do
    case data do
      %{"type" => type} ->
        Movies.Trailer.convert(data)
      %{"title" => title} ->
        Movies.Movie.convert(data)
      _ ->
        nil
    end
  end
end
