defmodule MazesForProgrammers.CellTest do
  use ExUnit.Case, async: true

  test "test cell create, set, get" do
    {:ok, cell} = Cell.start_link(0)
    assert 0 == Cell.get(cell)

    assert :ok == Cell.set(cell, 1)
    assert 1 == Cell.get(cell)
  end

  test "test north-south cells" do
    {:ok, cell1} = Cell.start_link(0)
    {:ok, cell2} = Cell.start_link(1)

    assert 0 == Cell.get(cell1)
    assert 1 == Cell.get(cell2)

    assert nil == Cell.north?(cell1)
    Cell.north(cell1, cell2)
    assert cell2 == Cell.north?(cell1)
    assert cell1 == Cell.south?(cell2)
    assert nil == Cell.south?(cell1)
    assert nil == Cell.north?(cell2)
  end

  test "test east-west cells" do
    {:ok, cell1} = Cell.start_link(0)
    {:ok, cell2} = Cell.start_link(1)

    assert 0 == Cell.get(cell1)
    assert 1 == Cell.get(cell2)

    assert nil == Cell.east?(cell1)
    Cell.east(cell1, cell2)
    assert cell2 == Cell.east?(cell1)
    assert cell1 == Cell.west?(cell2)
    assert nil == Cell.west?(cell1)
    assert nil == Cell.east?(cell2)
  end

  test "test compass" do
    {:ok, center} = Cell.start_link(0)
    {:ok, north} = Cell.start_link(1)
    {:ok, east} = Cell.start_link(2)
    {:ok, south} = Cell.start_link(3)
    {:ok, west} = Cell.start_link(4)

    Cell.north(center, north)
    Cell.east(center, east)
    Cell.south(center, south)
    Cell.west(center, west)

    assert north == Cell.north?(center)
    assert east == Cell.east?(center)
    assert south == Cell.south?(center)
    assert west == Cell.west?(center)

    assert center == Cell.south?(north)
    assert center == Cell.west?(east)
    assert center == Cell.north?(south)
    assert center == Cell.east?(west)
  end

end
