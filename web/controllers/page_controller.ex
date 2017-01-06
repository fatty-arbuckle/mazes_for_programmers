defmodule MazesForProgrammers.PageController do
  use MazesForProgrammers.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
