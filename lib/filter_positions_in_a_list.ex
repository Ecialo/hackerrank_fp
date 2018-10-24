defmodule Hackerrank.FilterPositionsInAList do
  def main do
    IO.read(:all)
      |> String.split()
      |> filter()
      |> Enum.join("\n")
      |> IO.write()
  end

  def filter(seq) do
    filter(seq, true)
  end

  def filter([], _) do
    []
  end

  def filter([_ | tail], is_odd = true) do
    filter(tail, not is_odd)
  end

  def filter([head | tail], is_odd = false) do
    [head | filter(tail, not is_odd)]
  end
end
