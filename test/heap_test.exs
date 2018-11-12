defmodule HeapTest do
  use ExUnit.Case
  alias Hackerrank.Candybox.{PairingHeap, SkewHeap, ListHeap}

  test "make skewheap 28 1 4 23 44 24 63" do
    v = [28, 1, 4, 23, 44, 24, 63]
    heap = SkewHeap.new(v)
    assert SkewHeap.peek(heap) == 63
    assert SkewHeap.to_list(heap) == [63, 44, 28, 24, 23, 4, 1]
  end

  test "skewheap merge" do
    h1 = SkewHeap.new([28, 1, 4, 23])
    h2 = SkewHeap.new([44, 24, 63])
    heap = SkewHeap.merge(h1, h2)
    assert SkewHeap.peek(heap) == 63
    assert SkewHeap.to_list(heap) == [63, 44, 28, 24, 23, 4, 1]
  end

  test "make pairingheap 28 1 4 23 44 24 63" do
    v = [28, 1, 4, 23, 44, 24, 63]
    heap = PairingHeap.new(v)
    assert PairingHeap.peek(heap) == 63
    assert PairingHeap.to_list(heap) == [63, 44, 28, 24, 23, 4, 1]
  end

  test "pairingheap merge" do
    h1 = PairingHeap.new([28, 1, 4, 23])
    h2 = PairingHeap.new([44, 24, 63])
    heap = PairingHeap.merge(h1, h2)
    assert PairingHeap.peek(heap) == 63
    assert PairingHeap.to_list(heap) == [63, 44, 28, 24, 23, 4, 1]
  end

  test "make listheap 28 1 4 23 44 24 63" do
    v = [28, 1, 4, 23, 44, 24, 63]
    heap = ListHeap.new(v)
    assert ListHeap.peek(heap) == 63
    assert ListHeap.to_list(heap) == [63, 44, 28, 24, 23, 4, 1]
  end

  test "listheap merge" do
    h1 = ListHeap.new([28, 1, 4, 23])
    h2 = ListHeap.new([44, 24, 63])
    heap = ListHeap.merge(h1, h2)
    assert ListHeap.peek(heap) == 63
    assert ListHeap.to_list(heap) == [63, 44, 28, 24, 23, 4, 1]
  end
end
