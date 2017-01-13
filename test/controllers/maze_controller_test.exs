defmodule MazesForProgrammers.MazeControllerTest do
  use MazesForProgrammers.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "get maze without a generator", %{conn: conn} do
    conn = get conn, maze_path(conn, :index, %{})
    assert json_response(conn, 400)["error"] == "invalid API call: you must specify a generator"
  end

  test "get maze with a generator", %{conn: conn} do
    conn = get conn, maze_path(conn, :index, %{"generator" => "test"})
    assert json_response(conn, 200)["data"]
      == %{"generator" => "test",
           "height" => 10,
           "width" => 10,
           "maze" => []}
  end

  test "get maze with a generator and dimensions", %{conn: conn} do
    conn = get conn, maze_path(conn, :index, %{"generator" => "test", "width" => "5", "height" => "5"})
    assert json_response(conn, 200)["data"] == %{"generator" => "test", "height" => 5, "width" => 5, "maze" => []}
  end

end
