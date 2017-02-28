defmodule MazesForProgrammers.MazeGenerator.BinaryTreeMaze do

  def generate(cols, rows) do
    maze = Maze.from_list(
      for y <- 1..cols do
        for x <- 1..rows do
          {:ok, cell} = Cell.start_link(((y-1)*3) + (x-1))
          cell
        end
      end)

    for {row_index, row} <- maze do
      for {col_index, _cell} <- row do
        above = Maze.above?(maze, col_index, row_index)
        right = Maze.right?(maze, col_index, row_index)

        neighbors = Enum.filter([{:north, above}, {:east, right}], fn ({_dir, cell}) ->
          cell != nil
        end)

        if Enum.count(neighbors) > 0 do
          {dir, _cell} = Enum.random(neighbors)
          Maze.make_path(dir, maze, col_index, row_index)
        end
      end
    end

    {matrix, w, h} = Maze.to_int_matrix(maze)
    { :ok, matrix, w, h }
  end

end
