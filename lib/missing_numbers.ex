defmodule Hackerrank.MissingNumbers do

  def main do
    s1 = read_list()
    s2 = read_list()
    (s2 -- s1)
      |> Enum.uniq()
      |> Enum.sort()
      |> Enum.join(" ")
      |> IO.write()
  end

  def read_list() do
    IO.read(:line)
    IO.read(:line)
      |> String.trim()
      |> String.split()
      |> Enum.map(&String.to_integer/1)
  end

end
