defmodule MazesForProgrammers.GeneratorController do
  use MazesForProgrammers.Web, :controller

  def index(conn, _params) do
    generators = MazesForProgrammers.MazeGenerator.maze_generators
    render(conn, "index.json", generators: generators)
  end

end
