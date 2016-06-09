defmodule Mix.Tasks.Elmer.Gen.Model do
  @shortdoc "Generates a Model file given a model definition."

  @moduledoc """
  This is a mix task for creating a Model template.
  """

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
  def run(args) do
    Mix.shell.info "Creating new elm Model..."

    # Get the app path
    app_path = Elmer.prompt_path
    [module, model_name | option_list] = args

    # Create the output directory from the app_path and parsing the module name
    module_path = String.split(module, ".") |> Path.join()
    output_directory = "#{app_path}/#{module_path}"

    # If the output directory doesn't exist we'll need to create it
    if not File.exists?(output_directory), do: File.mkdir_p(output_directory)

    elm_map = Elmer.ecto_elm
    defaults = Elmer.ecto_defaults
    
    # Parse out the options
    fields = Enum.map option_list, fn(model) ->
      [field, type | _] = String.split(model, ":")
      %{"field" => field, "type" => elm_map[type], "default_value" => defaults[type]}
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
