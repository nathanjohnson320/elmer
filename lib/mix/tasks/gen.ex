defmodule Mix.Tasks.Elmer.Gen.Msg do
  @shortdoc "Generates a Msg file given a list of Msgs."

  @moduledoc """
  This is a mix task for creating a Msg template.
  """

  use Mix.Task

  @doc """
  Creates a new elm Msg in the current directory.

  Run with `mix elmer.gen.msg <args>`

  Args are similar to phoenix gen arguments where they are in the format "MsgName:Type1:Type2:TypeN"

  * MsgName is the name of the message you want to generate
  * The types will be entered in exactly as you type them.
  * You can enter in as many messages as you want as long as they're separated by a space
  * Currently there's no way to set the root elm path so you have to enter it each time you generate.

  """
  def run(_args) do
    Mix.shell.info "Creating new elm Msg..."
    app_path = Mix.shell.prompt("What is the path to your elm app?\n|>")|> String.strip() |> Path.expand()

    {:ok, cwd} = File.cwd()
    [_ | module_name] = String.replace_leading(cwd, app_path, "") |> Path.split()

    # Parse CLI options into a map so they're easier to deal with
    {parsed_options, options, _} = OptionParser.parse(System.argv)

    # Remove the mix task "elmer.gen.msg"
    [_ | option_list] = options

    # Parse out the options
    messages = Enum.map option_list, fn(msg) ->
      [msg_spec | params] = String.split(msg, ":")
      %{"msg" => msg_spec, "params" => params}
    end
    output = EEx.eval_string(Elmer.Templates.render_msgs(), assigns: [messages: messages, modulename: module_name])

    # Write the output
    Mix.Generator.create_file(Path.expand(cwd) <> "/Msgs.elm", output)
  end
end
