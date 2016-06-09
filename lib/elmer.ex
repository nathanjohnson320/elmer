defmodule Elmer do
  @moduledoc """
  Elmer is a tool for generating common elm-lang structures. This module is for abstracting out common functions that many of the modules use.
  """
  def prompt_path do
    if is_nil Application.get_env(:elmer, :elmpath) do
      Mix.shell.info "Set :elmer, :elmpath in your app config to suppress this prompt."
      Mix.shell.prompt("What is the path to your elm app?\n|>")
      |> String.strip()
      |> Path.expand()
    else
      Application.get_env(:elmer, :elmpath)
    end
  end

  @doc """
  Returns a map of ecto types to elm types
  """
  def ecto_elm do
    %{
      "boolean" => "Bool",
      "integer" => "Int",
      "float"   => "Float",
      "string"  => "String",
      "map"     => "Record"
    }
  end

  @doc """
  Returns a map of default ecto values
  """
  def ecto_defaults do
    # Map of default values
    %{
      "boolean" => "False",
      "integer" => "0",
      "float"   => "0.0",
      "string"  => "\"\"",
      "map"     => "{}"
    }
  end
end
