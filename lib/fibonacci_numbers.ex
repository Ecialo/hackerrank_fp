defmodule Hackerrank.FibonacciNumbers do

  def main do
    IO.read(:line)
      |> String.trim
      |> String.to_integer
      |> fibonacci()
      |> IO.write
  end

  def fibonacci(0) do
    0
  end

  def fibonacci(1) do
    0
  end

  def fibonacci(2) do
    1
  end

  def fibonacci(x) do
    fibonacci(x - 1) + fibonacci(x - 2)
  end

end
