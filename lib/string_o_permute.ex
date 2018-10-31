defmodule Hackerrank.StringOPermute do

  def main do
    IO.read(:line)
    IO.read(:all)
      |> String.split("\n", trim: true)
      |> Enum.map(&permute/1)
      |> Enum.join("\n")
      |> IO.write()
  end

  def permute("") do
    ""
  end

  def permute(<<a::utf8, b::utf8, t::binary>>) do
    <<b::utf8, a::utf8, permute(t)::binary>>
  end
end
