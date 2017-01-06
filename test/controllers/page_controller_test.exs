defmodule MazesForProgrammers.PageControllerTest do
  use MazesForProgrammers.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "<div id=\"elm-container\"></div>"
  end
end
