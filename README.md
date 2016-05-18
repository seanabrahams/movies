# Movies

Elixir library for querying movie data.

The idea is to expose a standardized API for movie data that can be backed by any API. Right now it currently only supports themoviedb.org's API, however should there be movie info not available via themoviedb.org, this library should query other APIs to get the desired information.

This library is open source (MIT License) and welcomes contributions!

## Installation

1. Add movies to your list of dependencies in `mix.exs`:

      def deps do
        [{:movies, git: "https://github.com/seanabrahams/movies.git"}]
      end

You will need an <a href="https://www.themoviedb.org/account">account</a> and <a href="https://www.themoviedb.org/account">API key</a> from themoviedb.org.

```
config :movies,
  tmdb_api_key: "Your TMDb API key"
```

## Usage

```
Movies.search("coherence") # Search for a specific movie
Movies.popular() # Movies that are currently popular
Movies.top() # Most highly rated movies regardless of release date
```

## Todo
