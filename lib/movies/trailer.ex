# %{
#   "id" => "543d8f250e0a266f7d00059f",
#   "iso_3166_1" => "US",
#   "iso_639_1" => "en",
#   "key" => "7d_jQycdQGo",
#   "name" => "Whiplash trailer",
#   "site" => "YouTube",
#   "size" => 360,
#   "type" => "Trailer"
# }
defmodule Movies.Trailer do
  defstruct embed_url: "", id: "", language: "", name: "", url: ""

  def convert(data) do
    %Movies.Trailer{
      id: data["id"],
      embed_url: get_trailer_embed_url(data),
      language: data["iso_639_1"],
      name: data["name"],
      url: get_trailer_url(data)
    }
  end

  defp get_trailer_embed_url(data) do
    case data do
      %{"site" => "YouTube"} ->
        "https://www.youtube.com/embed/#{data["key"]}"
      _ ->
        nil
    end
  end

  defp get_trailer_url(data) do
    case data do
      %{"site" => "YouTube"} ->
        "https://www.youtube.com/watch?v=#{data["key"]}"
      _ ->
        nil
    end
  end
end
