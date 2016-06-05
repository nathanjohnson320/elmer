defmodule Mix.Tasks.Elmer.Gen.Cmd do
  @shortdoc "Generates a Cmd file given a list of Cmds."

  @moduledoc """
  Mix task to generate Cmds.elm files.
  """

  use Mix.Task

  @doc """
  Creates a new elm Cmd in the directory corresponding to your <module name>.

  Run with `mix elmer.gen.cmd <module name> <model> <args>`

  Currently this module is only setup to handle REST Cmds but in the future it will be able to handle multiple types

  Args are in the format "CmdName:Type:RequestType:FuncParams"

  * Type is "rest", for now
  * RequestType is: "GET", "PATCH", "POST", "DELETE", etc.
  * FuncParams are what get plugged into your Cmd function

  """
  def run(_args) do
    Mix.shell.info "Creating new Cmd..."

    # Get the app path
    app_path = Elmer.prompt_path

    # Parse CLI options
    {_, options, _} = OptionParser.parse(System.argv)

    # Remove the mix task "elmer.gen.cmd"
    [_, module, model | option_list] = options

    # Create the output directory from the app_path and parsing the module name
    module_path = String.split(module, ".") |> Path.join()
    output_directory = "#{app_path}/#{module_path}"

    # If the output directory doesn't exist we'll need to create it
    if not File.exists?(output_directory), do: File.mkdir_p(output_directory)

    # Parse out the options
    cmds = Enum.map option_list, fn(msg) ->
      [cmd, type, req | params] = String.split(msg, ":")
      %{"cmd" => cmd, "type" => type, "request" => req, "params" => params}
    end
    output = EEx.eval_string(Elmer.Templates.render_cmd(), assigns: [cmds: cmds, module_name: module, model: model])

    # Write the output
    Mix.Generator.create_file(output_directory <> "/Cmds.elm", output)
  end
end
