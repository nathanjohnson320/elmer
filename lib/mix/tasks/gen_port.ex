defmodule Mix.Tasks.Elmer.Gen.Port do
  @shortdoc "Generates a Port file given a Port, direction, and params."

  @moduledoc """
  Generates a Port.elm file
  """

  use Mix.Task

  @doc """
  Creates a new Port file in your elm path.

  Run with `mix elmer.gen.port <module name> <args>`
  
  Args are in the format "portName:direction:params portNameN:direction:paramN"

  * Direction is either inbound (Sub) or outbound (Cmd)
  * Params are the types that are input to your Port
    * port askDeleteConfirmation : ( Int, String ) -> Cmd msg | args would be askDeleteConfirmation:outboud:Int:String
    * port getDeleteConfirmation : (Int -> msg) -> Sub msg | args would be getDeleteConfirmation:inbound:Int
  * Currently does not add inbounds to subscriptions
  """
  def run(_args) do
    Mix.shell.info "Creating new elm Port..."

    # Get the app path
    app_path = Elmer.prompt_path

    # Parse CLI options into a map so they're easier to deal with
    {_, options, _} = OptionParser.parse(System.argv)

    # Remove the mix task "elmer.gen.port"
    [_, module | option_list] = options

    # Create the output directory from the app_path and parsing the module name
    module_path = String.split(module, ".") |> Path.join()
    output_directory = "#{app_path}/#{module_path}"

    # If the output directory doesn't exist we'll need to create it
    if not File.exists?(output_directory), do: File.mkdir_p(output_directory)

    # Parse out the options
    ports = Enum.map option_list, fn(port) ->
      [name, direction | params] = String.split(port, ":")
      %{"name" => name, "direction" => direction, "params" => params}
    end

    output = EEx.eval_string Elmer.Templates.render_port(), assigns: [
      ports: ports,
      module_name: module
    ]

    # Write the output
    Mix.Generator.create_file(output_directory <> "/Ports.elm", output)
  end
end
