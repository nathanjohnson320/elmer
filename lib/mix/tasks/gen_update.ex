defmodule Mix.Tasks.Elmer.Gen.Update do
  @shortdoc "Generates an Update file given Msgs and their params."

  @moduledoc """
  This is a mix task for creating an Update template.
  """

  use Mix.Task

  @doc """
  Creates a new Update file in your elm path.

  Run with `mix elmer.gen.update <module name> <args>`
  
  Args are in the format "Msg2:param1:param2 MsgN:paramN"

  By default all update clauses will return (model, Cmd.none), this may change in the future.
  """
  def run(_args) do
    Mix.shell.info "Creating new elm Update file..."

    # Get the app path
    app_path = Elmer.prompt_path

    # Parse CLI options into a map so they're easier to deal with
    {_, options, _} = OptionParser.parse(System.argv)

    # Remove the mix task "elmer.gen.update"
    [_, module | option_list] = options

    # Create the output directory from the app_path and parsing the module name
    module_path = String.split(module, ".") |> Path.join()
    output_directory = "#{app_path}/#{module_path}"

    # If the output directory doesn't exist we'll need to create it
    if not File.exists?(output_directory), do: File.mkdir_p(output_directory)

    # Parse out the options
    clauses = Enum.map option_list, fn(clause) ->
      [msg | params] = String.split(clause, ":")
      %{"msg" => msg, "params" => params}
    end

    output = EEx.eval_string Elmer.Templates.render_update(), assigns: [
      clauses: clauses,
      module_name: module
    ]

    # Write the output
    Mix.Generator.create_file(output_directory <> "/Update.elm", output)
  end
end
