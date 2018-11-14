defmodule Hackerrank.ListsAndGCD do

  def main do
    IO.read(:line)
    [h | tail] =
      IO.read(:all)
        |> String.split("\n")
        |> Enum.map(
            fn line ->
              line
                |> String.split()
                |> Enum.map(&String.to_integer/1)
                |> construct()
            end
           )
    tail
      |> Enum.reduce(h, &find_gcd/2)
      |> Enum.filter(fn {_k, v} -> v >= 1 end)
      |> Enum.sort()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.concat()
      |> Enum.join(" ")
      |> IO.write()
  end

  def construct(num) do
    num
      |> Enum.chunk_every(2)
      |> Enum.into(%{}, &List.to_tuple/1)
  end

  def find_gcd(num_a, num_b) do
    for key <- unikeys(num_a, num_b), into: %{} do
      va = Map.get(num_a, key, 0)
      vb = Map.get(num_b, key, 0)
      {key, min(va, vb)}
    end
  end

  def unikeys(data_a, data_b) do
    [Map.keys(data_a), Map.keys(data_b)]
      |> Enum.concat()
      |> Enum.uniq()
  end

end
