defmodule MazesForProgrammers.MazeController do
  use MazesForProgrammers.Web, :controller

  @default_dimension 10

  def index(conn, %{"generator" => generator, "width" => str_width, "height" => str_height}) do
    width = convert_dimension(str_width)
    height = convert_dimension(str_height)
    maze_data = MazesForProgrammers.MazeGenerator.generate(generator, width, height)
    reply(conn, generator, maze_data)
  end

  def index(conn, %{"generator" => generator}) do
    maze_data = MazesForProgrammers.MazeGenerator.generate(generator, @default_dimension, @default_dimension)
    reply(conn, generator, maze_data)
  end

  def index(conn, _params) do
    put_status(conn, 400)
    |> render("400.json", %{message: "you must specify a generator"})
  end

  defp reply(conn, generator, maze_data) do
    case maze_data do
      {:ok, data, width, height} ->
        render(conn, "index.json", mazes: %{
          generator: generator,
          width: width,
          height: height,
          maze: data
        })
      {:error, reason} ->
        put_status(conn, 400)
        |> render("400.json", %{message: reason})
    end
  end

  defp convert_dimension(s) do
    case Integer.parse(s) do
      {i, _} -> i
      :error -> @default_dimension
    end
  end

end
