defmodule Mix.Tasks.Elmer.Gen.Msg do
  @shortdoc "Generates a Msg file given a list of Msgs."

  @moduledoc """
  This is a mix task for creating a Msg template.
  """

  use Mix.Task

  @doc """
  Creates a new elm Msg in the directory corresponding to your <module name>.

  Run with `mix elmer.gen.msg <module name> <args>`

  module name is the module you want to place this Msg in, for example: Players.Striker will create the file <elmpath>/Players/Striker/Msgs.elm
  
  Args are similar to phoenix gen arguments where they are in the format "MsgName:Type1:Type2:TypeN"

  * MsgName is the name of the message you want to generate
  * The types will be entered in exactly as you type them.
  * You can enter in as many messages as you want as long as they're separated by a space

  """
  def run(args) do
    Mix.shell.info "Creating new elm Msg..."

    # Get the app path
    app_path = Elmer.prompt_path

    # Parse CLI options into a map so they're easier to deal with
    {_, options, _} = OptionParser.parse(args)
    [module | option_list] = options

    # Create the output directory from the app_path and parsing the module name
    module_path = String.split(module, ".") |> Path.join()
    output_directory = "#{app_path}/#{module_path}"

    # If the output directory doesn't exist we'll need to create it
    if not File.exists?(output_directory), do: File.mkdir_p(output_directory)

    # Parse out the options
    messages = Enum.map option_list, fn(msg) ->
      [msg_spec | params] = String.split(msg, ":")
      %{"msg" => msg_spec, "params" => params}
    end
    output = EEx.eval_string(Elmer.Templates.render_msgs(), assigns: [messages: messages, modulename: module])

    # Write the output
    Mix.Generator.create_file(output_directory <> "/Msgs.elm", output)
  end
end
