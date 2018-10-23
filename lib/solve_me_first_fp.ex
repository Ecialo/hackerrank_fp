defmodule Hackerrank.SolveMeFirstFP do
  def main do
    x = IO.read(:line) |> String.trim |> String.to_integer
    y = IO.read(:line) |> String.trim |> String.to_integer
    IO.write(sum(x, y))
  end

  def sum(x, y) do
    x + y
  end
end
