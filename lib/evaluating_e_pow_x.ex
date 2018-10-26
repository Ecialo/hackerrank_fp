defmodule Hackerrank.EvaluatingEPowX do

  alias Hackerrank.Candybox.Factorial

  def main do
    init()
    IO.read(:line)
    IO.read(:all)
      |> String.split
      |> Enum.map(
        fn x -> x
                |> String.to_float
                |> compute
                |> Float.round(4)
                |> Float.to_string
        end)
      |> Enum.join("\n")
      |> IO.write
  end

  def init do
    Factorial.start_link
  end

  def compute(x) do
    compute(x, {1, 1}, 1)
  end

  def compute(x, {prev_x, acc}, term) when term <= 9 do
    compute(x, {prev_x*x, acc + prev_x*x/Factorial.compute(term)}, term + 1)
  end

  def compute(_x, {_prev_x, acc}, term) when term > 9 do
    acc
  end

end
