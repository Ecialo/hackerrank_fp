defmodule Hackerrank.ComputingTheGCD do

  def main do
    IO.read(:line)
      |> String.trim
      |> String.split
      |> Enum.map(&String.to_integer/1)
      |> gcd
      |> IO.write
  end

  def gcd([a, b]) do
    gcd(a, b)
  end

  def gcd(a, 0) do
    a
  end

  def gcd(a, b) when a >= b do
    gcd(b, rem(a, b))
  end

  def gcd(a, b) when a < b do
    gcd(b, a)
  end

end
