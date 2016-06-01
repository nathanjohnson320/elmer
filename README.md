# Elmer

Elmer is a toolchain for generating elm code inside of an elixir app. Could also be used outside wherever mix is installed.


## Installation

Install globall with
`mix archive.install https://github.com/nathanjohnson320/elmer/archives/raw/elmer-0.0.3.ez

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add elmer to your list of dependencies in `mix.exs`:

        def deps do
          [{:elmer, "~> 0.0.1"}]
        end

  2. Ensure elmer is started before your application:

        def application do
          [applications: [:elmer]]
        end

