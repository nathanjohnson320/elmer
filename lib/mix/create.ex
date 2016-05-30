defmodule Mix.Tasks.Elmer.Create do
  use Mix.Task

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
      "b" => Path.expand("./templates/b/beginnerprogram.elm") |> File.read!,
      "h" => Path.expand("./templates/h/htmlprogram.elm") |> File.read!,
      "n" => Path.expand("./templates/n/navigationprogram.elm") |> File.read!
    }

    # Write the template to our app dir
    File.write "#{path}/Main.elm", templates[type]
  end
end
