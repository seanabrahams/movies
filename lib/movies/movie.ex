# %{
# "adult" => false,
# "backdrop_path" => "/m5O3SZvQ6EgD5XXXLPIP1wLppeW.jpg",
# "genre_ids" => [28, 53, 878],
# "id" => 271110,
# "original_language" => "en",
# "original_title" => "Captain America: Civil War",
# "overview" => "Following the events of Age of Ultron, the collective governments of the world pass an act designed to regulate all superhuman activity. This polarizes opinion amongst the Avengers, causing two factions to side with Iron Man or Captain America, which causes an epic battle between former allies.",
# "popularity" => 81.623523,
# "poster_path" => "/rDT86hJCxnoOs4ARjrCiRej7pOi.jpg",
# "release_date" => "2016-04-27",
# "title" => "Captain America: Civil War",
# "video" => false,
# "vote_average" => 6.91,
# "vote_count" => 1348
# }
defmodule Movies.Movie do
  defstruct id: "", language: "", tmdb_id: "", title: "", image_url: "", description: "", genres: [], rating: "", trailer_url: "", year: ""

  def convert(data) do
    %Movies.Movie{
      id: data["id"],
      description: data["overview"],
      genres: get_genres(data),
      image_url: get_image_url(data),
      language: data["original_language"],
      rating: data["vote_average"],
      title: data["title"],
      tmdb_id: data["id"],
      year: get_year(data),
      trailer_url: get_trailer_url(data),
    }
  end

  defp get_genres(data) do
    case data["genre_ids"] do
      nil -> []
      "" -> []
      genre_ids ->
        Enum.map(genre_ids, fn(id) -> @tmdb_genres[id] end)
    end
  end

  defp get_image_url(data) do
    case data["poster_path"] do
      nil -> nil
      "" -> nil
      poster_path ->
        "https://image.tmdb.org/t/p/w500#{data["poster_path"]}"
    end
  end

  defp get_trailer_url(data) do
    trailers = case data do
      %{"trailers" => %{"youtube" => trailers}} ->
        Enum.map(trailers, &Movies.Trailer.convert/1)
      _ ->
        []
    end

    trailer = Enum.at(trailers, 0)
    case trailer do
      %{url: url} ->
        url
      _ ->
        nil
    end
  end

  defp get_year(data) do
    case data["release_date"] do
      nil -> nil
      "" -> nil
      release_date ->
        [year, _, _] = String.split(release_date, "-")
        year
    end
  end
end
