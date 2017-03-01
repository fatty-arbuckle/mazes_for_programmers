defmodule MazesForProgrammers.MazeGenerator.SidewinderMaze do

  def generate(cols, rows) do
    maze = Maze.from_list(
      for y <- 1..cols do
        for x <- 1..rows do
          {:ok, cell} = Cell.start_link(((y-1)*3) + (x-1))
          cell
        end
      end)

    for {_row_index, row} <- maze do
      runs = Enum.chunk_by(row, fn (_cell) ->
        Enum.random([0,1]) == 0
      end)

      Enum.each(runs, &link_run(maze, &1))
    end

    {matrix, w, h} = Maze.to_int_matrix(maze)
    { :ok, matrix, w, h }
  end

  defp link_run(maze, run) do
    link_east_west(run)
    link_north(maze, run)
  end

  defp link_east_west(run) do
    Enum.scan(run, nil, fn (cell, prev) ->
      if prev != nil do
        {_, this} = cell
        {_, that} = prev
        Cell.west(this, that)
      end
      cell
    end)
  end

  defp link_north(maze, run) do
    {_index, cell} = Enum.random(run)
    case Maze.above?(maze, cell) do
      nil ->
        link_east(maze, run)
      above ->
        Cell.north(cell, above)
    end
  end

  defp link_east(maze, run) do
    {:ok, {_, cell}} = Enum.fetch(run, -1)
    right = Maze.right?(maze, cell)
    if right != nil do
      Cell.east(cell, right)
    end
  end

end
