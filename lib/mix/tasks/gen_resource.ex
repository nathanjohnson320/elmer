defmodule Mix.Tasks.Elmer.Gen.Resource do
  @shortdoc "Generates Model, View, Update, Msg files given a model definition."

  @moduledoc """
  Creates a complete Elm resource (Model, Update, Msgs, Listview, Editview, Cmds).
  """

  use Mix.Task

  @doc """
  Creates a new elm Model in your elm path.

  Run with `mix elmer.gen.model <module name> <args>`

  Args are similar to phoenix gen arguments where they are in the format "Model Pluralmodel field1:type1 fieldN:typeN"

  Example: mix elmer.gen.edit_view Players Player players name:string level:integer

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

    # Parse CLI options into a map so they're easier to deal with
    [module, model_name, plural_model | option_list] = args
    
    # Generate the model
    model_args = [ module, model_name ] ++ option_list
    Mix.Task.run "elmer.gen.model", model_args

    # Create the list of args to generate
    elm_map = Elmer.ecto_elm
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
      "Delete#{model_name}:Int",
      "Delete#{model_name}Success:#{model_name}",
      "Delete#{model_name}Error:Http.Error",
      "Save#{model_name}Success:#{model_name}",
      "Save#{model_name}Error:Http.Error",
      "NoOp"
    ] ++ Enum.map option_list, fn(model) ->
      [field, type | _] = String.split(model, ":")
      "Change#{String.capitalize(field)}:Int:#{elm_map[type]}"
    end

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

    # Build the update args
    update_args = [
      module,
      "List#{model_name}",
      "Edit#{model_name}:#{String.downcase model_name}",
      "FetchAllSuccess:#{String.downcase model_name}s",
      "FetchAllError:error",
      "Create#{model_name}",
      "Create#{model_name}Success:#{String.downcase model_name}",
      "Create#{model_name}Error:error",
      "Delete#{model_name}:id",
      "Delete#{model_name}Success:#{String.downcase model_name}",
      "Delete#{model_name}Error:error",
      "Save#{model_name}Success:#{String.downcase model_name}",
      "Save#{model_name}Error:error"
    ] ++ Enum.map option_list, fn(model) ->
      [field, type | _] = String.split(model, ":")
      "Change#{String.capitalize(field)}:id:value"
    end
    Mix.Task.run "elmer.gen.update", update_args

    # Now render the views
    Mix.Task.run "elmer.gen.list_view", args
    Mix.Task.run "elmer.gen.edit_view", args
  end
end
