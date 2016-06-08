defmodule Mix.Tasks.Elmer.Gen.Resource do
  @shortdoc "Generates Model, View, Update, Msg files given a model definition."

  @moduledoc """
  Creates a complete Elm resource (Model, Update, Msgs, Listview, Editview, Cmds).
  """

  use Mix.Task

  @doc """
  Creates a new elm Model in your elm path.

  Run with `mix elmer.gen.model <module name> <args>`

  Args are similar to phoenix gen arguments where they are in the format "Model field1:type1 fieldN:typeN"

  Example: mix elmer.gen.resource Players Player id:integer name:string 

  * Model is the name of the model you want to generate
  * Types will be mapped from elixir (ecto types) to elm
      * :boolean -> Boolean
      * :integer -> Int
      * :float   -> Float
      * :string  -> String
      * :map     -> Record
  """
  def run(args) do
    Mix.shell.info "Creating new elm Resource..."

    # Generate the model
    Mix.Task.run "elmer.gen.model", args

    # Parse CLI options into a map so they're easier to deal with
    {_, options, _} = OptionParser.parse(args)
    [module, model_name | option_list] = options

    # Create the list of args to generate
    msg_args = [
      module,
      # All the messages we need to generate
      "List#{model_name}",
      "Edit#{model_name}:Int",
      "FetchAllSuccess:(List #{model_name})",
      "FetchAllError:Http.Error",
      "Create#{model_name}",
      "Create#{model_name}Success:#{model_name}",
      "Create#{model_name}Error:Http.Error",
      "Delete#{model_name}Intent:#{model_name}",
      "Delete#{model_name}:Int",
      "Delete#{model_name}Success:#{model_name}",
      "Delete#{model_name}Error:Http.Error",
      "Save#{model_name}Success:#{model_name}",
      "Save#{model_name}Error:Http.Error"
    ]

    # Generate the message
    Mix.Task.run "elmer.gen.msg", msg_args

    # Create the list of cmd args
    cmd_args = [
      module,
      model_name,
      # All the Cmds we need to generate
      "Create#{model_name}:rest:POST:#{model_name}",
      "FetchAll:rest:GET",
      "Delete#{model_name}:rest:DELETE:#{model_name}",
      "Save#{model_name}:rest:PATCH:#{model_name}"
    ]
    Mix.Task.run "elmer.gen.cmd", cmd_args    
  end
end
