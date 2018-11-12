defmodule Hackerrank.Candybox.PairingHeap do

  alias __MODULE__

  defstruct [value: nil, subheaps: []]

  def new([h | t]) do
    Enum.reduce(
      t,
      new(h),
      fn x, acc -> merge(acc, x) end
    )
  end

  def new(value) do
    %PairingHeap{value: value}
  end

  def new(value, subheaps) do
    %PairingHeap{value: value, subheaps: subheaps}
  end

  def merge(heap, o_heap) when nil in [heap, o_heap] do
    max(heap, o_heap)
  end

  def merge(
    heap = %PairingHeap{value: v},
    o_heap = %PairingHeap{value: ov}
  ) when v < ov do
    merge(o_heap, heap)
  end

  def merge(
    %PairingHeap{value: v, subheaps: subheaps},
    o_heap = %PairingHeap{}
  ) do
    new(v, [o_heap | subheaps])
  end

  def merge(heap = %PairingHeap{}, o_heap) do
    merge(heap, new(o_heap))
  end

  def add(heap, value) do
    merge(heap, new(value))
  end

  def pop(%PairingHeap{subheaps: subheaps}) do
    merge_pairs(subheaps)
  end

  def merge_pairs([]), do: nil
  def merge_pairs([sh]), do: sh
  def merge_pairs([sh1, sh2 | t]) do
    merge(
      merge(sh1, sh2),
      merge_pairs(t)
    )
  end

  def peek(%PairingHeap{value: v}) do
    v
  end

  def to_list(heap = %PairingHeap{}) do
    heap |> to_list([]) |> Enum.reverse()
  end

  def to_list(nil, l) do
    l
  end

  def to_list(heap = %PairingHeap{}, l) do
    to_list(pop(heap), [peek(heap) | l])
  end

end
