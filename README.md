# Elmer

Elmer is a toolchain for generating elm code inside of an elixir app. Could also be used outside wherever mix is installed.


## Installation

Add :elmer, elmroot: "path to my elm root folder" to your config. Then use mix tasts to generate apps, msgs, models, etc.


If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add elmer to your list of dependencies in `mix.exs`:

        def deps do
          [{:elmer, "~> 0.0.1", only: :dev}]
        end

