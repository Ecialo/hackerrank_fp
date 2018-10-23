defmodule Hackerrank.ListReplication do

  def main do
    x = IO.read(:line) |> String.trim |> String.to_integer
    IO.read(:all)
      |> String.split
      |> replicate(x)
      |> Enum.join("\n")
      |> IO.write
  end

  def replicate([], _) do
    []
  end

  def replicate([head | tail], times) do
    List.duplicate(head, times) ++ replicate(tail, times)
  end

end
