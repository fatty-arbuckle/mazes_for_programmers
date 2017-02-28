defmodule MazesForProgrammers.MatrixTest do
  use ExUnit.Case, async: true

  test "test matrix from list" do
    matrix = Matrix.from_list([
      ["1", "2", "3"],
      ["4", "5", "6"],
      ["7", "8", "9"]
    ])
    assert matrix == %{
      0 => %{0 => "1", 1 => "2", 2 => "3"},
      1 => %{0 => "4", 1 => "5", 2 => "6"},
      2 => %{0 => "7", 1 => "8", 2 => "9"}
    }
  end

  test "test matrix from list of atoms" do
    matrix = Matrix.from_list([
      [:true, :false, :true],
      [:true, :false, :false],
      [:true, :true, :true]
    ])
    assert matrix == %{
      0 => %{0 => :true, 1 => :false, 2 => :true},
      1 => %{0 => :true, 1 => :false, 2 => :false},
      2 => %{0 => :true, 1 => :true, 2 => :true}
    }
  end

  test "test get/set matrix of atoms" do
    matrix = Matrix.from_list([
      [:false, :false, :false],
      [:false, :false, :false],
      [:false, :false, :false]
    ])
    assert matrix == %{
      0 => %{0 => :false, 1 => :false, 2 => :false},
      1 => %{0 => :false, 1 => :false, 2 => :false},
      2 => %{0 => :false, 1 => :false, 2 => :false}
    }

    assert :false == matrix[0][1]
    matrix = put_in matrix[0][1], :true
    assert :true == matrix[0][1]
  end

  test "matrix create/destroy" do
    {:ok, server} = Matrix.create(3, 3, 2)
    assert [[2,2,2],[2,2,2],[2,2,2]] == Matrix.to_list(server)
    Matrix.set(server, 0, 0, 1)
    Matrix.set(server, 1, 0, 2)
    Matrix.set(server, 2, 0, 3)
    Matrix.set(server, 0, 1, 4)
    Matrix.set(server, 1, 1, 5)
    Matrix.set(server, 2, 1, 6)
    Matrix.set(server, 0, 2, 7)
    Matrix.set(server, 1, 2, 8)
    Matrix.set(server, 2, 2, 9)
    assert [[1,2,3],[4,5,6],[7,8,9]] == Matrix.to_list(server)
    Matrix.destroy(server)
  end

end
