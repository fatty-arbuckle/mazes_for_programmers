defmodule MazesForProgrammers.MazeView do
  use MazesForProgrammers.Web, :view

  def render("index.json", %{mazes: mazes}) do
    %{data: mazes}
  end

  def render("400.json", assigns) do
    %{
      error: "invalid API call: " <> assigns.message
    }
  end

end
