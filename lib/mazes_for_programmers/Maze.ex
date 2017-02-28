# borrowed from,
# http://blog.danielberkompas.com/2016/04/23/multidimensional-arrays-in-elixir.html

defmodule Maze do
  @moduledoc """
  A maze is a matrix of Cells.
  """

  @doc """
  Converts a multidimensional list into a zero-indexed map.
  """
  def from_list(list) when is_list(list) do
    do_from_list(list)
  end

  @doc """
  Converts a zero-indexed map into a multidimensional list.
  """
  def to_list(maze) when is_map(maze) do
    do_to_list(maze)
  end

  # compass directions are for "moving" between connected cells
  # above/below/left/right are for finding neighbors regardless
  #   of the connections

  def above?(maze, x, y) when y > 0 do
    maze[y - 1][x]
  end
  def above?(_maze, _x, _y) do
    nil
  end

  def below?(maze, x, y) do
    case y <= (Enum.count(maze) - 2) do
      true -> maze[y + 1][x]
      false -> nil
    end
  end

  def left?(maze, x, y) when x > 0 do
    maze[y][x - 1]
  end
  def left?(_maze, _x, _y) do
    nil
  end

  def right?(maze, x, y) do
    case y <= (Enum.count(maze[y]) - 2) do
      true -> maze[y][x + 1]
      false -> nil
    end
  end

  @doc """
  Returns the value of the cell "north" of the given cell.
  """
  def north?(maze, x, y) when is_map(maze) do
    Cell.north?(maze[y][x])
  end

  @doc """
  Returns the value of the cell "south" of the given cell.
  """
  def south?(maze, x, y) when is_map(maze) do
    Cell.south?(maze[y][x])
  end

  @doc """
  Returns the value of the cell "east" of the given cell.
  """
  def east?(maze, x, y) when is_map(maze) do
    Cell.east?(maze[y][x])
  end

  @doc """
  Returns the value of the cell "west" of the given cell.
  """
  def west?(maze, x, y) when is_map(maze) do
    Cell.west?(maze[y][x])
  end

  def make_path(:north, maze, x, y) do
    from = maze[y][x]
    case y > 0 do
      true ->
        to = maze[y - 1][x]
        Cell.north(from, to)
      false ->
        nil
    end
  end
  def make_path(:east, maze, x, y) do
    from = maze[y][x]
    case x < (Enum.count(maze[x]) - 1) do
      true ->
        to = maze[y][x + 1]
        Cell.east(from, to)
      false ->
        nil
    end
  end
  def make_path(:south, maze, x, y) do
    from = maze[y][x]
    case y < (Enum.count(maze) - 1) do
      true ->
        to = maze[y + 1][x]
        Cell.south(from, to)
      false ->
        nil
    end
  end
  def make_path(:west, maze, x, y) do
    from = maze[y][x]
    case x > 0 do
      true ->
        to = maze[y][x - 1]
        Cell.west(from, to)
      false ->
        nil
    end
  end

  def to_int_matrix(maze) when is_map(maze) do
    {cols, rows} = dimentions(maze)
    {nh, nw} = {2*rows + 1, 2*cols + 1}
    {:ok, server} = Matrix.create(nh, nw, 1)

    for {row_index, row} <- maze do
      for {col_index, cell} <- row do
        server_x = 2*col_index + 1
        server_y = 2*row_index + 1
        set_int_maze(cell, server, server_x, server_y)
        set_int_maze(Cell.north?(cell), server, server_x, server_y - 1)
        set_int_maze(Cell.east?(cell), server, server_x + 1, server_y)
        set_int_maze(Cell.south?(cell), server, server_x, server_y + 1)
        set_int_maze(Cell.west?(cell), server, server_x - 1, server_y)
      end
    end

    result = Matrix.to_list(server)
    Matrix.destroy(server)
    {result, nw, nh}
  end

  defp set_int_maze(cell, _server, _x, _y) when is_nil(cell) do
  end
  defp set_int_maze(_cell, server, x, y) do
    Matrix.set(server, x, y, 0)
  end

  defp dimentions(maze) when is_map(maze) do
    rows = Enum.count(maze)
    cols = Enum.count(maze[0])
    {cols, rows}
  end

  defp do_from_list(list, map \\ %{}, index \\ 0)
  defp do_from_list([], map, _index), do: map
  defp do_from_list([h|t], map, index) do
    map = Map.put(map, index, do_from_list(h))
    do_from_list(t, map, index + 1)
  end
  defp do_from_list(other, _, _), do: other

  defp do_to_list(maze) when is_map(maze) do
    for {_index, value} <- maze,
        into: [],
        do: do_to_list(value)
  end
  # defp do_to_list(other), do: other
  defp do_to_list(other), do: Cell.get(other)
end
