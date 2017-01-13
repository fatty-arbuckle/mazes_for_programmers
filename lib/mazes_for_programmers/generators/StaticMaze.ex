defmodule MazesForProgrammers.MazeGenerator.StaticMaze do

  def generate(5, 5) do
    { :ok,
      [ [1, 1, 1, 1, 1],
        [0, 0, 1, 0, 1],
        [1, 0, 1, 0, 1],
        [1, 0, 0, 0, 0],
        [1, 1, 1, 0, 1],
      ]
    }
  end

  def generate(_w, _h) do
    {:error, "static maze is 5x5"}
  end

end