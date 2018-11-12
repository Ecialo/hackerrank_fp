defmodule Hackerrank.FightingArmiesTrashApproach do

  def main do
    {n, _} = IO.read(:line) |> Integer.parse()
    state = :array.new(n + 1, [fixed: true, default: []])
    Enum.reduce(IO.binstream(:stdio, :line), state, &process/2)
  end

  def parse(line, v \\ 0, acc \\ [])
  def parse(<<>>, v, acc), do: Enum.reverse([v|acc])
  def parse("\n", v, acc), do: parse("", v, acc)
  def parse(<<32, rest::binary>>, v, acc), do: parse(rest, 0, [v|acc])
  def parse(<<c, rest::binary>>, v, acc) do
    parse(rest, v * 10 + (c - ?0), acc)
  end

  def process(line, state) do
    case parse(line) do
      [1, army] ->
        IO.puts(hd(:array.get(army, state)))
        state
      [2, army] ->
        :array.set(
          army,
          tl(:array.get(army, state)),
          state
        )
      [3, army, power] ->
        :array.set(
          army,
          add(:array.get(army, state), power),
          state
        )
      [4, army_a, army_b] ->
        :array.set(
          army_a,
          merge(
            :array.get(army_a, state),
            :array.get(army_b, state)
          ),
          state
        )
    end
  end

  def merge(as, bs, acc \\ [])
  def merge([a | as], [b | bs], acc) when a >= b, do: merge(as, [b|bs], [a|acc])
  def merge([a | as], [b | bs], acc), do: merge([a|as], bs, [b|acc])
  def merge([], bs, acc), do: Enum.reverse(acc, bs)
  def merge(as, [], acc), do: Enum.reverse(acc, as)

  def add(l, v, acc \\ [])
  def add([h | t], v, acc) when h > v, do: add(t, v, [h|acc])
  def add(l, v, acc), do: Enum.reverse(acc, [v|l])

end
