defmodule Cell do
  def start_link(name) do
    Agent.start_link(fn -> %{name: name} end)
  end

  def north?(cell) do
    Agent.get(cell, &Map.get(&1, :north))
  end
  def north(cell, n) do
    Agent.update(cell, &Map.put(&1, :north, n))
    Agent.update(n, &Map.put(&1, :south, cell))
  end

  def south?(cell) do
    Agent.get(cell, &Map.get(&1, :south))
  end
  def south(cell, n) do
    Agent.update(cell, &Map.put(&1, :south, n))
    Agent.update(n, &Map.put(&1, :north, cell))
  end

  def east?(cell) do
    Agent.get(cell, &Map.get(&1, :east))
  end
  def east(cell, n) do
    Agent.update(cell, &Map.put(&1, :east, n))
    Agent.update(n, &Map.put(&1, :west, cell))
  end

  def west?(cell) do
    Agent.get(cell, &Map.get(&1, :west))
  end
  def west(cell, n) do
    Agent.update(cell, &Map.put(&1, :west, n))
    Agent.update(n, &Map.put(&1, :east, cell))
  end


  def get(cell) do
    Agent.get(cell, &Map.get(&1, :name))
  end

  def set(cell, name) do
    Agent.update(cell, &Map.put(&1, :name, name))
  end
end
