defmodule Hackerrank.PrefixCompression do

  def main do
    x = IO.read(:line) |> String.trim
    y = IO.read(:line) |> String.trim
    compress_prefix(x, y)
      |> Enum.map(fn {n, s} -> "#{n} #{s}" end)
      |> Enum.join("\n")
      |> IO.write
  end

  def compress_prefix(a, b) do
    compress_prefix(a, b, [])
  end

  def compress_prefix(
    a = <<h_a::utf8, tail_a::binary>>,
    b = <<h_b::utf8, tail_b::binary>>,
    prefix
    ) do
      if h_a == h_b do
        compress_prefix(tail_a, tail_b, [h_a | prefix])
      else
        finalise(a, b, prefix)
      end
  end

  def compress_prefix(a, b, acc) when "" in [a, b] do
    finalise(a, b, acc)
  end

  def finalise(a, b, prefix) do
    Enum.map([prefix |> Enum.reverse |> List.to_string, a, b], &expand/1)
  end

  def expand(x) do
    {String.length(x), x}
  end

end
