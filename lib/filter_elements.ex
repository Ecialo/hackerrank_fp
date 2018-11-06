defmodule Hackerranck.FilterElements do

  def filter(elements, k) do
    elements
      |> aggregate(0, %{})
      |> Enum.filter(fn {_k, {_spos, times}} -> times >= k end)
      |> Enum.sort(fn {_, {spos_a, _}}, {_, {spos_b, _}} -> spos_a < spos_b end)
      |> Enum.map()  
  end

  def aggregate([], _, acc) do
    acc
  end

  def aggregate([h | t], pos, acc) do
    if h in acc do
      {spos, times} = acc[h]
      aggregate(t, pos + 1, %{acc | h => {spos, times + 1}})
    else
      aggregate(t, pos + 1, Map.put(acc, h, {pos, 1}))
    end
  end

end
