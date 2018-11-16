defmodule Hackerrank.SuperDigit do

  def main do
    [n, k] = IO.read(:line) |> String.trim() |> String.split()
    super_digit(n)
      |> :erlang.*(String.to_integer(k))
      |> super_digit()
      |> IO.write()
  end

  def super_digit(x) when is_binary(x) do
    super_digit(String.to_charlist(x))
  end

  def super_digit(x) when is_integer(x) and x in 0..9 do
    x
  end

  def super_digit(x) when is_integer(x) do
    super_digit(Integer.to_charlist(x))
  end

  def super_digit(x) when is_list(x) do
    x |> Enum.reduce(0, fn x, acc -> acc + (x - ?0) end) |> super_digit()
  end

end
