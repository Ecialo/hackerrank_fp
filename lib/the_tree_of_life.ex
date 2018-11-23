defmodule Hackerrank.TheTreeOfLife.Tree do

  alias __MODULE__

  defstruct [val: nil, left: "0", right: "0"]

  def new(val) do
    %Tree{val: val}
  end

  def parse_tree(t, acc \\ [])

  def parse_tree("", [tree]) do
    tree
  end

  def parse_tree(<<" ", t::binary>>, acc) do
    parse_tree(t, acc)
  end

  def parse_tree(<<".", t::binary>>, acc) do
    parse_tree(t, [Tree.new("0") | acc])
  end

  def parse_tree(<<"X", t::binary>>, acc) do
    parse_tree(t, [Tree.new("1") | acc])
  end

  def parse_tree(<<"(", t::binary>>, acc) do
    {new_t, [left, val, right]} = parse_tree(t, [])
    parse_tree(new_t, [%Tree{val: val.val, left: left, right: right} | acc])
  end

  def parse_tree(<<")", t::binary>>, acc) do
    {t, Enum.reverse(acc)}
  end

end

defmodule Hackerrank.TheTreeOfLife.State do

  use Agent

  alias Hackerrank.TheTreeOfLife.Tree

  def start_link(tree, rule) do
    Agent.start_link(fn -> {%{0 => tree}, rule} end, name: __MODULE__)
  end

  def find([time, q]) do
    # time = String.to_integer(time)
    Agent.get_and_update(__MODULE__, &(query(&1, time, q)))
  end

  def query(%Tree{left: left}, <<"<", t::binary>>) do
    query(left, t)
  end

  def query(%Tree{right: right}, <<">", t::binary>>) do
    query(right, t)
  end

  def query(%Tree{val: val}, "]") do
    case val do
      "0" -> "."
      "1" -> "X"
    end
  end

  def query(tree, _) when is_binary(tree) do
    :error
  end

  def query(state = {tree_map, _}, x, q = <<"[", t::binary>>) do
    case Map.fetch(tree_map, x) do
      {:ok, tree} -> {query(tree, t), state}
      :error -> query(fill(state, x), x, q)
    end
  end

  def fill({tree_map, rule}, x) do
    case Map.fetch(tree_map, x - 1) do
      {:ok, tree} -> {Map.put(tree_map, x, apply_rule(tree, rule)), rule}
      :error -> fill(fill({tree_map, rule}, x - 1), x)
    end
  end

  def apply_rule(tree, path \\ ["0"], rule)
  def apply_rule(
    %Tree{val: val, left: left, right: right},
    path = [h | _],
    rule
  ) do
    %Tree{
      val: rule[h <> get(left) <> val <> get(right)],
      left: apply_rule(left, [val | path], rule),
      right: apply_rule(right, [val | path], rule)
    }
  end

  def apply_rule(tree, _, _) do
    tree
  end

  def get(%Tree{val: val}) do
    val
  end

  def get(tree) when is_binary(tree) do
    tree
  end

end


defmodule Hackerrank.TheTreeOfLife do

  alias Hackerrank.TheTreeOfLife.{Tree, State}

  @rule_size 16

  def main do
    rule =
      IO.read(:line)
        |> String.trim()
        |> String.to_integer()
        |> construct_rule()
    tree = IO.read(:line) |> String.trim() |> Tree.parse_tree()
    State.start_link(tree, rule)
    IO.read(:line)
    IO.read(:all)
      |> String.split("\n", trim: true)
      |> Enum.scan({0, nil}, &process_query/2)
      |> Enum.map(fn {_, v} -> v end)
      |> Enum.join("\n")
      |> IO.write()
  end

  def process_query(l, {time, _}) do
    [n, q] = String.split(l)
    atime = time + String.to_integer(n)
    {atime, State.find([atime, q])}
  end

  def construct_rule(x, size \\ @rule_size)
  def construct_rule(x, size) when is_integer(x) and is_integer(size) do
    rule_string = x |> Integer.to_string(2) |> String.pad_leading(size, "0")
    state_size = Integer.to_string(size - 1, 2) |> String.length()
    construct_rule(rule_string, size - 1, state_size, %{})
  end

  def construct_rule("", _, _, acc) do
    acc
  end

  def construct_rule(
    <<h::binary-size(1), t::binary>>,
    state,
    state_size,
    acc
  ) do
    key =
      state
        |> Integer.to_string(2)
        |> String.pad_leading(state_size, "0")
    construct_rule(t, state - 1, state_size, Map.put(acc, key, h))
  end

end
