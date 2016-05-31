defmodule Mix.Tasks.Elmer.New do
  @shortdoc "Creates new elm applications"
  @moduledoc """
  This is a mix task for creating new elm applications.
  """

  use Mix.Task

  @doc """
  Creates a new elm application in directory specified by the user.

  Run with `mix elmer.new`

  Different types of apps can be generated:

  * Beginner (http://package.elm-lang.org/packages/elm-lang/html/1.0.0/Html-App#beginnerProgram) which generates:
      * Main.elm
      * elm-package.json
  * HTML (http://package.elm-lang.org/packages/elm-lang/html/1.0.0/Html-App#program) which generates:
      * Main.elm
      * Models.elm
      * Msgs.elm
      * Update.elm
      * View.elm
      * elm-package.json
  * Navigation (http://package.elm-lang.org/packages/elm-lang/navigation/1.0.0/Navigation#program) which generates:
      * Main.elm
      * Models.elm
      * Msgs.elm
      * Ports.elm
      * RouteMsgs.elm
      * Routing.Elm
      * Update.elm
      * View.elm
      * elm-package.json

  These types correspond to the main types of elm programs.


  """
  def run(_args) do
    Mix.shell.info "Creating new elm app..."

    # Get the path to their app
    app_path = Mix.shell.prompt("What is the path to your elm app?\n|>")
    |> String.strip()
    |> Path.expand()

    # Make the folder if it doesn't already exist
    case File.mkdir(Path.expand(app_path)) do
      :ok ->
        # Get what type of app this is
        app_type = Mix.shell.prompt("What type of application is this?\n(B)eginner\n(H)TML\n(N)avigation\n|>")

        # Write the default Main files based on the app type
        create_main(app_path, app_type)

        Mix.shell.info "App created in #{app_path}"
      {:error, :eexist} -> Mix.shell.info "App directory already exists"
      err -> IO.inspect err
    end
  end

  # Copies over the specific type of file into our app_path
  defp create_main(path, type) do
    # Downcase the type to avoid inconsistencies
    type = String.downcase(type) |> String.strip

    # Map of the available templates
    templates = %{
      "b" => [{Path.expand("./templates/b/beginnerprogram.elm"), "Main.elm"},
              {Path.expand("./templates/b/elm-package.json"), "elm-package.json"}
             ],
      "h" => [{Path.expand("./templates/h/htmlprogram.elm"), "Main.elm"},
              {Path.expand("./templates/h/models.elm"), "Models.elm"},
              {Path.expand("./templates/h/msgs.elm"), "Msgs.elm"},
              {Path.expand("./templates/h/view.elm"), "View.elm"},
              {Path.expand("./templates/h/update.elm"), "Update.elm"},
              {Path.expand("./templates/h/elm-package.json"), "elm-package.json"}
             ],
      "n" => [{Path.expand("./templates/n/navigationprogram.elm"), "Main.elm"},
              {Path.expand("./templates/n/models.elm"), "Models.elm"},
              {Path.expand("./templates/n/msgs.elm"), "Msgs.elm"},
              {Path.expand("./templates/n/ports.elm"), "Ports.elm"},
              {Path.expand("./templates/n/routemsgs.elm"), "RouteMsgs.elm"},
              {Path.expand("./templates/n/routing.elm"), "Routing.elm"},
              {Path.expand("./templates/n/update.elm"), "Update.elm"},
              {Path.expand("./templates/n/view.elm"), "View.elm"},
              {Path.expand("./templates/n/elm-package.json"), "elm-package.json"}
             ]
    }

    # Write the template to our app dir
    Enum.each templates[type], fn({template, filename}) ->
      contents = File.read!(template)
      File.write("#{path}/#{filename}", contents)
    end
  end
end
