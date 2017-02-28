defmodule MazesForProgrammers.MazeGenerator do
  @maze_generators [ "static", "random", "binarytree" ]

  def maze_generators do
    @maze_generators
  end

  def generate("static", width, height) do
    MazesForProgrammers.MazeGenerator.StaticMaze.generate(width, height)
  end

  def generate("random", width, height) do
    MazesForProgrammers.MazeGenerator.RandomMaze.generate(width, height)
  end

  def generate("binarytree", width, height) do
    MazesForProgrammers.MazeGenerator.BinaryTreeMaze.generate(width, height)
  end

  def generate(generator, _width, _height) do
    {:error, "no such generator '" <> generator <> "'"}
  end

end
