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

  # def genres do
  #   get!("genre/movie/list?").body
  # end
  #
  # def images(movie) do
  #   get!("movie/#{movie.tmdb_id}/images?").body
  # end

  # body: %{
  #     "page" => 1,
  #     "results" => [ ... Movies ... ]
  #     ],
  #     "total_pages" => 1,
  #     "total_results" => 1
  #   },
  # }
  def search(query) do
    get!("search/movie?query=#{query}").body
  end

  # %{
  #   "page" => 1,
  #   "results" => [ ... Movies ... ]
  #   "total_pages" => 985,
  #   "total_results" => 19684
  # }
  def popular do
    get!("movie/popular?").body
  end

  def similar(movie) do
    get!("movie/#{movie.tmdb_id}/similar?").body
  end

  def top do
    get!("movie/top_rated?").body
  end

  def upcoming do
    get!("movie/upcoming?").body
  end

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
  #   body: ...
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

  defp to_struct(%{"results" => results}) do
    convert(results)
  end

  defp convert(data) when is_list(data) do
    Enum.map(data, &(convert(&1)))
  end

  defp convert(data) do
    %Movies.Movie{
      tmdb_id: data["id"],
      title: data["title"],
      image_url: "https://image.tmdb.org/t/p/w185/#{data["poster_path"]}",
      description: data["overview"],
      genres: get_genres(data),
    }
  end

  defp get_genres(data) do
    case data["genre_ids"] do
      nil -> []
      genre_ids ->
        Enum.map(genre_ids, fn(id) -> @tmdb_genres[id] end)
    end
  end
end
