defmodule Hackerrank.Candybox.PrefixTree do

  alias __MODULE__, as: PTNode

  defstruct [terminal: false, transitions: %{}]

  @type t :: %PTNode{terminal: boolean(), transitions: %{optional(binary()) => PTNode.t()}}

  def new do
    %PTNode{}
  end


  def terminal?(%PTNode{terminal: t}) do
    t
  end


  def add_elem(ptnode=%PTNode{transitions: t}, e, terminal \\ false) do
    if Map.has_key?(t, e) do
      stored_node = t[e]
      updated_node = %PTNode{stored_node | terminal: PTNode.terminal?(stored_node) or terminal}
      %PTNode{ptnode | transitions: %{t | e => updated_node}}
    else
      new_node = %PTNode{terminal: terminal}
      %PTNode{ptnode | transitions: Map.put(t, e, new_node)}
    end
  end


  @spec move(t(), any()) :: :error | {:ok, any()}
  def move(%PTNode{transitions: t}, k) do
    Map.fetch(t, k)
  end


  def add_string(ptnode, string, node_stack \\ [], elements_stack \\ [])

  def add_string(ptnode = %PTNode{}, <<h::binary-size(1)>>, stack, elements_stack) do
    uptnode = PTNode.add_elem(ptnode, h, true)
    merge(uptnode, stack, elements_stack)
  end

  def add_string(ptnode = %PTNode{}, <<h::binary-size(1), rest::binary>>, stack, elements_stack) do
    uptnode = PTNode.add_elem(ptnode, h)
    {:ok, nnode} = PTNode.move(uptnode, h)
    add_string(nnode, rest, [uptnode | stack], [h | elements_stack])
  end

  def merge(ptnode, [], []), do: ptnode
  def merge(ptnode, [h = %PTNode{transitions: t} | nt], [eh | et]) do
    uptnode = %PTNode{h | transitions: %{t | eh => ptnode}}
    merge(uptnode, nt, et)
  end

end
