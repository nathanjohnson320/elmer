# Elmer

Elmer is a toolchain for generating elm code inside of an elixir app.

Check the hex docs for all the mix tasks that are available and the format of their arguments.

## Installation

Add :elmer, elmroot: "path to my elm root folder" to your config. Then use mix tasts to generate apps, msgs, models, etc.

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add elmer to your list of dependencies in `mix.exs`:

        def deps do
          [{:elmer, "~> 0.0.10", only: :dev}]
        end

# V1 Roadmap
 - ~~Msg generator~~
 - ~~View generator~~
 - ~~Model generator~~
 - ~~Update generator~~
 - ~~Decoder generator~~
 - ~~Encoder generator~~
 - ~~Cmd generator~~
 - ~~Port generator~~
 - Resource generator (Msg, View, Model, Update)
 - Phoenix resource generator (Resource + phoenix gen.json for API)
