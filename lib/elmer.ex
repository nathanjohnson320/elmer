defmodule Elmer do
  def prompt_path do
    if is_nil Application.get_env(:elmer, :elmpath) do
      Mix.shell.info "Set :elmer, :elmpath in your app config to suppress this prompt."
      Mix.shell.prompt("What is the path to your elm app?\n|>")|> String.strip() |> Path.expand()
    else
      Application.get_env(:elmer, :elmpath)
    end
  end
end
