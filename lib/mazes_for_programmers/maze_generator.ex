defmodule MazesForProgrammers.MazeGenerator do
  @maze_generators [ "static" ]

  def maze_generators do
    @maze_generators
  end

  def generate("static", width, height) do
    MazesForProgrammers.MazeGenerator.StaticMaze.generate(width, height)
  end

  def generate(generator, _width, _height) do
    {:error, "no such generator '" <> generator <> "'"}
  end

end
