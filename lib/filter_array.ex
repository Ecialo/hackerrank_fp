defmodule Hackerrank.FilterArray do
  def main do
    x = IO.read(:line) |> String.trim |> String.to_integer
    IO.read(:all)
      |> String.split
      |> Enum.map(&String.to_integer(&1))
      |> filter(x)
      |> Enum.join("\n")
      |> IO.write
  end

  def filter([], _) do
    []
  end

  def filter([head | tail], x) when head < x do
    [head | filter(tail, x)]
  end

  def filter([head | tail], x) when head >= x do
    filter(tail, x)
  end
end
