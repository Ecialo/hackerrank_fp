defmodule Hackerrank.Candybox.Combinatoric do

  @spec flatten({tuple(), any()}) :: tuple()
  def flatten({t_a, b}) when is_tuple(t_a), do: Tuple.append(t_a, b)
  def flatten(t = {_a, _b}), do: t

  @spec product(list(), list()) :: [tuple()]
  def product(p, q), do: for a <- p, b <- q, do: {a, b}
  @spec product([[any()]]) :: [tuple()]
  def product([]), do: []
  def product([p, q]), do: product(p, q)
  def product([p, q | t]), do: [product(p, q) | t] |> product() |> Enum.map(&flatten/1)

  @spec permutations(tuple()) :: [tuple()]
  def permutations(t) when is_tuple(t) do
    s = tuple_size(t)

    t
    |> Tuple.to_list()
    |> List.duplicate(s)
    |> product()
    |> Enum.filter(fn pt ->
      pt
      |> Tuple.to_list()
      |> MapSet.new()
      |> MapSet.size()
      |> :erlang.==(s)
      end)
  end

  def combinations(t, r) do
    t
    |> Tuple.to_list()
    |> List.duplicate(r)
    |> product()
    |> Enum.map(fn x -> x |> Tuple.to_list() |> MapSet.new() end)
    |> Enum.filter(fn x -> MapSet.size(x) == r end)
    |> Enum.uniq()
    |> Enum.map(fn pt -> pt |> MapSet.to_list() |> List.to_tuple() end)
  end

end
