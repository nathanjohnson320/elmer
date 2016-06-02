defmodule Mix.Tasks.Elmer.Gen.View do
  @shortdoc "Generates a barebones View file."

  @moduledoc """
  This is a mix task for creating a View template.
  """

  use Mix.Task

  @doc """
  Creates a new elm View in your elm path.

  Run with `mix elmer.gen.view <module name>`
  """
  def run(_args) do
    Mix.shell.info "Creating new elm View..."

    # Get the app path
    app_path = Elmer.prompt_path

    # Parse CLI options into a map so they're easier to deal with
    {_, options, _} = OptionParser.parse(System.argv)

    # Remove the mix task "elmer.gen.view"
    [_, module | _] = options

    # Create the output directory from the app_path and parsing the module name
    module_path = String.split(module, ".") |> Path.join()
    output_directory = "#{app_path}/#{module_path}"

    # If the output directory doesn't exist we'll need to create it
    if not File.exists?(output_directory), do: File.mkdir_p(output_directory)

    output = EEx.eval_string Elmer.Templates.render_view(), assigns: [module_name: module]

    # Write the output
    Mix.Generator.create_file(output_directory <> "/View.elm", output)
  end
end
