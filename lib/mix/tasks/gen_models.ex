defmodule Mix.Tasks.Elmer.Gen.Model do
  @shortdoc "Generates a Model file given a model definition."

  @moduledoc """
  This is a mix task for creating a Model template.
  """

  # Map of ecto to Elm types
  @type_map %{
    "boolean" => "Boolean",
    "integer" => "Int",
    "float"   => "Float",
    "string"  => "String",
    "map"     => "Record"
  }

  # Map of default values
  @value_map %{
    "boolean" => "False",
    "integer" => "0",
    "float"   => "0.0",
    "string"  => "\"\"",
    "map"     => "{}"
  }

  use Mix.Task

  @doc """
  Creates a new elm Model in your elm path.

  Run with `mix elmer.gen.model <module name> <args>`
  
  Args are similar to phoenix gen arguments where they are in the format "Model field1:type1 fieldN:typeN"

  * Model is the name of the model you want to generate
  * Types will be mapped from elixir (ecto types) to elm
      * :boolean -> Boolean
      * :integer -> Int
      * :float   -> Float
      * :string  -> String
      * :map     -> Record
  """
  def run(_args) do
    Mix.shell.info "Creating new elm Model..."

    # Get the app path
    app_path = Elmer.prompt_path

    # Parse CLI options into a map so they're easier to deal with
    {_, options, _} = OptionParser.parse(System.argv)

    # Remove the mix task "elmer.gen.model"
    [_, module, model_name | option_list] = options

    # Create the output directory from the app_path and parsing the module name
    module_path = String.split(module, ".") |> Path.join()
    output_directory = "#{app_path}/#{module_path}"

    # If the output directory doesn't exist we'll need to create it
    if not File.exists?(output_directory), do: File.mkdir_p(output_directory)

    # Parse out the options
    fields = Enum.map option_list, fn(model) ->
      [field, type | _] = String.split(model, ":")
      %{"field" => field, "type" => @type_map[type], "default_value" => @value_map[type]}
    end

    output = EEx.eval_string Elmer.Templates.render_model(), assigns: [
          model_name: model_name,
          fields: fields,
          modulename: module
        ]

    # Write the output
    Mix.Generator.create_file(output_directory <> "/Models.elm", output)
  end
end
