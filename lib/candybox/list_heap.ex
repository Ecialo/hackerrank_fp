defmodule Hackerrank.Candybox.ListHeap do

  def new(l) when is_list(l) do
    l |> Enum.sort() |> Enum.reverse()
  end

  def new(nil), do: []
  def new(value), do: [value]

  def merge(as, bs, acc \\ [])
  def merge([a | as], [b | bs], acc) when a >= b, do: merge(as, [b|bs], [a|acc])
  def merge([a | as], [b | bs], acc), do: merge([a|as], bs, [b|acc])
  def merge([], bs, acc), do: Enum.reverse(acc, bs)
  def merge(as, [], acc), do: Enum.reverse(acc, as)
  def merge(nil, bs, acc), do: Enum.reverse(acc, bs)
  def merge(as, nil, acc), do: Enum.reverse(acc, as)

  def add(l, v, acc \\ [])
  def add([h | t], v, acc) when h > v, do: add(t, v, [h|acc])
  def add(l, v, acc), do: Enum.reverse(acc, [v|l])

  def pop([_ | t]), do: t

  def peek([h | _]), do: h

  def to_list(heap), do: heap

end
