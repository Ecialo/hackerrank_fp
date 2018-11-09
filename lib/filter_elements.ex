defmodule Hackerranck.FilterElements do

  def main do
    cases = IO.read(:line) |> String.trim() |> String.to_integer()
    process_case(cases)
  end

  def process_case(0) do end
  def process_case(cases_left) do
    [_, k] = IO.read(:line) |> String.split()
    k = String.to_integer(k)
    IO.read(:line)
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> filter(k)
      |> Enum.map(&Integer.to_string/1)
      |> Enum.join(" ")
      |> IO.puts()
    process_case(cases_left - 1)
  end

  def filter(elements, k) do
    elements
      |> aggregate(0, %{})
      |> Enum.filter(fn {_k, {_spos, times}} -> times >= k end)
      |> Enum.sort(fn {_, {spos_a, _}}, {_, {spos_b, _}} -> spos_a < spos_b end)
      |> Enum.map(fn {k, {_spos, _times}} -> k end)
      |> (fn r ->
            case r do
              [] -> [-1]
              l -> l
            end
          end).()
  end

  def aggregate([], _, acc) do
    acc
  end

  def aggregate([h | t], pos, acc) do
    # IO.inspect(h, label: "head")
    # IO.inspect(acc, label: "acc")
    if Map.has_key?(acc, h) do
      {spos, times} = acc[h]
      aggregate(t, pos + 1, %{acc | h => {spos, times + 1}})
    else
      aggregate(t, pos + 1, Map.put(acc, h, {pos, 1}))
    end
  end

end
