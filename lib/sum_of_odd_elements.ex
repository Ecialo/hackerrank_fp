defmodule Hackerrank.SumOfOddElements do

  def main do
    IO.read(:all)
      |> String.split
      |> Enum.map(&String.to_integer/1)
      |> sum
      |> IO.write
  end

  def sum(seq) do
    sum(seq, 0)
  end

  def sum([], acc) do
    acc
  end

  def sum([head | tail], acc) when rem(head, 2) != 0 do
    sum(tail, acc + head)
  end

  def sum([head | tail], acc) when rem(head, 2) == 0 do
    sum(tail, acc)
  end

end
