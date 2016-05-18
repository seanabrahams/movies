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
  defstruct id: "", tmdb_id: "", title: "", image_url: "", description: "", genres: [], year: ""
end
