defmodule Hackerrank.FightingArmies do

  # alias Hackerrank.Candybox.SkewHeap, as: Heap
  # alias Hackerrank.Candybox.PairingHeap, as: Heap
  alias Hackerrank.Candybox.ListHeap, as: Heap

  def main do
    [n, _] = IO.read(:line) |> String.trim() |> String.split()
    state = :array.new(String.to_integer(n) + 1, [fixed: true, default: nil])
    IO.read(:all)
      |> String.splitter("\n")
      |> Enum.reduce(
          {state, []},
          fn line, state ->
            process(state, parse(line))
          end
         )
      |> print_result()
  end

  def parse(line, v \\ 0, acc \\ [])
  def parse(<<>>, v, acc), do: Enum.reverse([v|acc])
  def parse("\n", v, acc), do: parse("", v, acc)
  def parse(<<" ", rest::binary>>, v, acc), do: parse(rest, 0, [v|acc])
  def parse(<<c, rest::binary>>, v, acc) do
    parse(rest, v * 10 + (c - ?0), acc)
  end

  def process({state, output}, [1, army]) do
    value =
      state
        |> get_army(army)
        |> Heap.peek()
    {state, [Integer.to_string(value) | output]}
  end

  def process({state, output}, [2, army]) do
    state =
      state
        |> get_army(army)
        |> Heap.pop()
        |> (fn h -> set_army(state, army, h) end).()
    {state, output}
  end

  def process({state, output}, [3, army, power]) do
    state =
      state
        |> get_army(army)
        |> Heap.add(power)
        |> (fn h -> set_army(state, army, h) end).()
    {state, output}
  end

  def process({state, output}, [4, army_a, army_b]) do
    state = set_army(
      state,
      army_a,
      Heap.merge(
        get_army(state, army_a),
        get_army(state, army_b)
      )
    )
    {state, output}
  end

  def set_army(state, army, h) do
    :array.set(army, h, state)
  end

  def get_army(state, army) do
    :array.get(army, state)
  end

  def print_result({_, output}) do
    output
      |> Enum.reverse()
      |> Enum.join("\n")
      |> IO.write()
  end

end
