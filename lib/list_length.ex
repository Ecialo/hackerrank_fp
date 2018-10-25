defmodule Hackerrank.ListLength do
  def main do
    IO.read(:all)
    |> String.split
    |> len
    |> IO.write
  end

  def len(seq) do
    len(seq, 0)
  end

  def len([], acc) do
    acc
  end

  def len([_ | tail], acc) do
    len(tail, acc + 1)
  end
end
