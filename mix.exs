defmodule Elmer.Mixfile do
  use Mix.Project

  def project do
    [app: :elmer,
     name: "Elmer",
     description: "Helper mix tasks for generating elm files like Main, Ports, Models, Msgs, etc.",
     source_url: "https://github.com/nathanjohnson320/elmer",
     package: package,
     version: "0.0.14",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.11", only: :dev},
     {:credo, "~> 0.3", only: :dev}]
  end

  defp package do
    [# These are the default files included in the package
      name: :elmer,
      maintainers: ["Nathan Johnson"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/nathanjohnson320/elmer"}]
  end
end
