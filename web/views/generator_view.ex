defmodule MazesForProgrammers.GeneratorView do
  use MazesForProgrammers.Web, :view

  def render("index.json", %{generators: generators}) do
    %{data: generators}
  end

end
