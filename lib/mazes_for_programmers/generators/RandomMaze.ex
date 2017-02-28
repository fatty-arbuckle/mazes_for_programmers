defmodule MazesForProgrammers.MazeGenerator.RandomMaze do

  def generate(cols, rows) do
    maze =  for _y <- 1..cols, do:
              for _x <- 1..rows, do:
                Enum.random([0,1])
    { :ok, maze, rows, cols }
  end

end
