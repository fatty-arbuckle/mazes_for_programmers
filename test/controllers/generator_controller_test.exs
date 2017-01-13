defmodule MazesForProgrammers.GeneratorControllerTest do
  use MazesForProgrammers.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, generator_path(conn, :index)
    assert json_response(conn, 200)["data"] == MazesForProgrammers.MazeGenerator.maze_generators
  end

end
