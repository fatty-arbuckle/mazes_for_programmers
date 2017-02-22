defmodule MazesForProgrammers.MazeGenerator.RandomMaze do

  def generate(cols, rows) do
    maze =  for y <- 1..cols, do:
              for x <- 1..rows, do:
                Enum.random([0,1])
    { :ok, maze }
  end

end
