defmodule Mix.Tasks.Elmer.Gen.EditView do
  @shortdoc "Generates a View file that allows editing a model."

  @moduledoc """
  This is a mix task for creating a EditView template.
  """

  use Mix.Task

  @doc """
  Creates a new elm View which has form fields which correspond to.

  Run with `mix elmer.gen.edit_view <module name> <model_name> <plural model> <args>`

  Example: mix elmer.gen.edit_view Players Player players name:string level:integer
  """
  def run(args) do
    Mix.shell.info "Creating new elm View..."

    # Get the app path
    app_path = Elmer.prompt_path
    [module, model_name, plural_model | params] = args

    # Create the output directory from the app_path and parsing the module name
    module_path = String.split(module, ".") |> Path.join()
    output_directory = "#{app_path}/#{module_path}"

    # If the output directory doesn't exist we'll need to create it
    if not File.exists?(output_directory), do: File.mkdir_p(output_directory)

    elm_map = Elmer.ecto_elm
    defaults = Elmer.ecto_defaults

    fields = Enum.map params, fn(model) ->
      [field, type | _] = String.split(model, ":")
      %{"field" => field, "type" => elm_map[type], "default_value" => defaults[type]}
    end

    output = EEx.eval_string Elmer.Templates.render_edit_view(), assigns: [
      model_name: model_name,
      fields: fields,
      module_name: module,
      model_plural: plural_model
    ]

    # Write the output
    Mix.Generator.create_file(output_directory <> "/Edit.elm", output)
  end
end
