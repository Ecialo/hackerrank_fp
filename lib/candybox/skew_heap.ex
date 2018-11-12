defmodule Hackerrank.Candybox.SkewHeap do

  alias __MODULE__

  defstruct [value: nil, left: nil, right: nil]

  def new([h | t]) do
    Enum.reduce(
      t,
      new(h),
      fn x, acc -> merge(acc, x) end
    )
  end

  def new(value) do
    %SkewHeap{value: value}
  end

  def merge(heap, o_heap) when nil in [heap, o_heap] do
    max(heap, o_heap)
  end

  def merge(
    heap = %SkewHeap{value: v},
    o_heap = %SkewHeap{value: ov}
  ) when v < ov do
    merge(o_heap, heap)
  end

  def merge(
    %SkewHeap{value: v, left: l, right: r},
    o_heap = %SkewHeap{}
  ) do
    %SkewHeap{value: v, right: l, left: merge(r, o_heap)}
  end

  def merge(heap = %SkewHeap{}, o_heap) do
    merge(heap, new(o_heap))
  end

  def add(heap, value) do
    merge(heap, new(value))
  end

  def pop(%SkewHeap{left: l, right: r}) do
    merge(l, r)
  end

  def peek(%SkewHeap{value: v}) do
    v
  end

  def to_list(heap = %SkewHeap{}) do
    heap |> to_list([]) |> Enum.reverse()
  end

  def to_list(nil, l) do
    l
  end

  def to_list(heap = %SkewHeap{}, l) do
    to_list(pop(heap), [peek(heap) | l])
  end

end
