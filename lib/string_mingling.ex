defmodule Hackerrank.StringMingling do

  def main do
    s_a = IO.read(:line) |> String.trim
    s_b = IO.read(:line) |> String.trim
    merge(s_a, s_b) |> IO.write
  end

  def merge(s_a, s_b) do
    merge(s_a, s_b, []) |> Enum.reverse |> List.to_string
  end

  def merge("", "", acc) do
    acc
  end

  def merge(<<h_a::utf8, t::binary>>, s_b, acc) do
    merge(s_b, t, [h_a | acc])
  end

end
