# borrowed from,
# http://blog.danielberkompas.com/2016/04/23/multidimensional-arrays-in-elixir.html

defmodule Matrix do
  use GenServer

  ## Client API
  def create(rows, cols, value \\ 1) do
    GenServer.start_link(__MODULE__, {:ok, rows, cols, value})
  end

  def destroy(server) do
    GenServer.stop(server)
  end

  def set(server, x, y, value) do
    GenServer.call(server, {:set, x, y, value})
  end


  @doc """
  Converts a multidimensional list into a zero-indexed map.
  """
  def from_list(list) when is_list(list) do
    do_from_list(list)
  end

  @doc """
  Converts a zero-indexed map into a multidimensional list.
  """
  def to_list(matrix) when is_map(matrix) do
    do_to_list(matrix)
  end
  def to_list(server) do # assumes it is a genserver
    to_list(GenServer.call(server, {:get}))
  end

  ## Server API
  def init({:ok, rows, cols, value}) do
    matrix = Matrix.from_list (
      for _y <- 1..rows do
        for _x <- 1..cols do
          value
        end
      end
    )
    {:ok, matrix}
  end

  def handle_call({:get}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:set, x, y, value}, _from, state) do
    state = put_in state[y][x], value
    {:reply, state, state}
  end


  ## Helpers

  defp do_from_list(list, map \\ %{}, index \\ 0)
  defp do_from_list([], map, _index), do: map
  defp do_from_list([h|t], map, index) do
    map = Map.put(map, index, do_from_list(h))
    do_from_list(t, map, index + 1)
  end
  defp do_from_list(other, _, _), do: other

  defp do_to_list(matrix) when is_map(matrix) do
    for {_index, value} <- matrix,
        into: [],
        do: do_to_list(value)
  end
  # defp do_to_list(other), do: other
  defp do_to_list(other), do: other
end
