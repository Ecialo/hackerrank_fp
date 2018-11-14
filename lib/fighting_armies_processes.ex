defmodule Hackerrank.FightingArmies.State do
  use Agent
  # alias Hackerrank.Candybox.SkewHeap, as: Heap
  alias Hackerrank.Candybox.PairingHeap, as: Heap
  # alias Hackerrank.Candybox.ListHeap, as: Heap

  def start_link(n) do
    Agent.start_link(
      fn -> {:array.new(n, [fixed: true, default: nil]), []} end,
      name: __MODULE__
    )
  end

  def process([command | args]) do
    case command do
      1 -> Agent.cast(__MODULE__, &find_max(&1, args))
      2 -> Agent.cast(__MODULE__, &pop(&1, args))
      3 -> Agent.cast(__MODULE__, &add(&1, args))
      4 -> Agent.cast(__MODULE__, &merge(&1, args))
    end
  end

  def find_max({state, output}, [army]) do
    {state, [Heap.peek(:array.get(army, state)) | output]}
  end

  def pop({state, output}, [army]) do
    {
      :array.set(
        army,
        Heap.pop(:array.get(army, state)),
        state
      ),
      output
    }
  end

  def add({state, output}, [army, power]) do
    {
      :array.set(
        army,
        Heap.add(:array.get(army, state), power),
        state
      ),
      output
    }
  end

  def merge({state, output}, [army_a, army_b]) do
    {
      :array.set(
        army_a,
        Heap.merge(
          :array.get(army_a, state),
          :array.get(army_b, state)
        ),
        state
      ),
      output
    }
  end

  def print_output() do
    output = Agent.get(
      __MODULE__,
      fn {_state, output} -> output end
    )
    output
      |> Enum.reverse()
      |> Enum.join("\n")
      |> IO.write()
  end

end

defmodule Hackerrank.FightingArmiesProcesses do

  # alias Hackerrank.Candybox.SkewHeap, as: Heap
  # alias Hackerrank.Candybox.PairingHeap, as: Heap
  # alias Hackerrank.Candybox.ListHeap, as: Heap
  alias Hackerrank.FightingArmies.State

  def main do
    [n, _] = IO.read(:line) |> String.trim() |> String.split()
    State.start_link(String.to_integer(n) + 1)
    IO.read(:all)
      |> String.splitter("\n")
      |> Enum.map(fn line -> State.process(parse(line)) end)
    State.print_output()
  end

  def parse(line, v \\ 0, acc \\ [])
  def parse(<<>>, v, acc), do: Enum.reverse([v|acc])
  def parse("\n", v, acc), do: parse("", v, acc)
  def parse(<<" ", rest::binary>>, v, acc), do: parse(rest, 0, [v|acc])
  def parse(<<c, rest::binary>>, v, acc) do
    parse(rest, v * 10 + (c - ?0), acc)
  end

end
