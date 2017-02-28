defmodule MazesForProgrammers.MazeTest do
  use ExUnit.Case, async: true

  setup do
    raw_data =  for y <- 1..3 do
              for x <- 1..3 do
                {:ok, cell} = Cell.start_link(((y-1)*3) + (x-1))
                cell
              end
            end
    {:ok, [raw_data: raw_data]}
  end

  test "test maze from list", context do
    maze = Maze.from_list(context[:raw_data])

    assert 0 == Cell.get(maze[0][0])
    assert 1 == Cell.get(maze[0][1])
    assert 2 == Cell.get(maze[0][2])
    assert 3 == Cell.get(maze[1][0])
    assert 4 == Cell.get(maze[1][1])
    assert 5 == Cell.get(maze[1][2])
    assert 6 == Cell.get(maze[2][0])
    assert 7 == Cell.get(maze[2][1])
    assert 8 == Cell.get(maze[2][2])
  end

  test "test off-map requests", context do
    maze = Maze.from_list(context[:raw_data])
    assert Maze.above?(maze, 0, 0) == nil
    assert Maze.above?(maze, 1, 0) == nil
    assert Maze.above?(maze, 2, 0) == nil
    assert Maze.right?(maze, 2, 0) == nil
    assert Maze.right?(maze, 2, 1) == nil
    assert Maze.right?(maze, 2, 2) == nil
    assert Maze.below?(maze, 0, 2) == nil
    assert Maze.below?(maze, 1, 2) == nil
    assert Maze.below?(maze, 2, 2) == nil
    assert Maze.left?(maze, 0, 0) == nil
    assert Maze.left?(maze, 0, 1) == nil
    assert Maze.left?(maze, 0, 2) == nil
  end

  test "test directions", context do
    maze = Maze.from_list(context[:raw_data])

    center = maze[1][1]
    assert Cell.get(center) == 4

    above = Maze.above?(maze, 1, 1)
    assert above != nil
    assert Cell.get(above) == 1

    below = Maze.below?(maze, 1, 1)
    assert below != nil
    assert Cell.get(below) == 7

    left = Maze.left?(maze, 1, 1)
    assert left != nil
    assert Cell.get(left) == 3

    right = Maze.right?(maze, 1, 1)
    assert right != nil
    assert Cell.get(right) == 5
  end

  test "test non-connected requests", context do
    maze = Maze.from_list(context[:raw_data])

    center = maze[1][1]
    assert Cell.get(center) == 4

    assert Maze.north?(maze, 1, 1) == nil
    assert Maze.east?(maze, 1, 1) == nil
    assert Maze.south?(maze, 1, 1) == nil
    assert Maze.west?(maze, 1, 1) == nil
  end

  test "test compass", context do
    maze = Maze.from_list(context[:raw_data])

    Maze.make_path(:north, maze, 1, 1)
    Maze.make_path(:east, maze, 1, 1)
    Maze.make_path(:south, maze, 1, 1)
    Maze.make_path(:west, maze, 1, 1)

    center = maze[1][1]
    north = Maze.north?(maze, 1, 1)
    east = Maze.east?(maze, 1, 1)
    south = Maze.south?(maze, 1, 1)
    west = Maze.west?(maze, 1, 1)

    assert Cell.get(center) == 4

    assert north != nil
    assert east != nil
    assert south != nil
    assert west != nil

    assert Cell.get(north) == 1
    assert Cell.get(east) == 5
    assert Cell.get(south) == 7
    assert Cell.get(west) == 3
  end

  test "test maze to_int_matrix", context do
    maze = Maze.from_list(context[:raw_data])

    Maze.make_path(:south, maze, 0, 0)
    Maze.make_path(:south, maze, 0, 1)
    Maze.make_path(:east, maze, 0, 2)
    Maze.make_path(:north, maze, 1, 2)
    Maze.make_path(:north, maze, 1, 1)
    Maze.make_path(:east, maze, 1, 0)
    Maze.make_path(:south, maze, 2, 0)
    Maze.make_path(:south, maze, 2, 1)

    expected = [
      [ 1, 1, 1, 1, 1, 1, 1 ],
      [ 1, 0, 1, 0, 0, 0, 1 ],
      [ 1, 0, 1, 0, 1, 0, 1 ],
      [ 1, 0, 1, 0, 1, 0, 1 ],
      [ 1, 0, 1, 0, 1, 0, 1 ],
      [ 1, 0, 0, 0, 1, 0, 1 ],
      [ 1, 1, 1, 1, 1, 1, 1 ],
    ]

    assert expected == Maze.to_int_matrix maze
  end

end
