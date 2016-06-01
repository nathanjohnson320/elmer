defmodule Mix.Tasks.Elmer.Gen.Msg do
  @shortdoc "Generates a Msg file given a list of Msgs."

  @moduledoc """
  This is a mix task for creating a Msg template.
  """

  use Mix.Task

  @doc """
  """
  def run(_args) do
    Mix.shell.info "Creating new elm Msg..."

    # Parse CLI options into a map so they're easier to deal with
    {parsed_options, options, _} = OptionParser.parse(System.argv)

    # Remove the mix task "elmer.gen.msg"
    [_ | option_list] = options

    # Parse out the options
    messages = Enum.map option_list, fn(msg) ->
      [msg_spec | params] = String.split(msg, ":")
      %{"msg" => msg_spec, "params" => params}
    end
    output = EEx.eval_string(Elmer.Templates.render_msgs(), assigns: [messages: messages])

    # Write the output
    Mix.Generator.create_file(Path.expand("./Msgs.elm"), output)

    IO.inspect Path.wildcard("**/elm-package.json")
  end
end
