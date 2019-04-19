defmodule CombinatoricTest do
  use ExUnit.Case
  alias Hackerrank.Candybox.Combinatoric

  test "product" do
    empty = Combinatoric.product([])
    assert empty == []

    pairs = Combinatoric.product([1, 2], [3, 4])
    assert pairs == [{1, 3}, {1, 4}, {2, 3}, {2, 4}]

    triplets = Combinatoric.product([[1, 2], [3, 4], [5, 6]])
    assert triplets == [
      {1, 3, 5},
      {1, 3, 6},
      {1, 4, 5},
      {1, 4, 6},
      {2, 3, 5},
      {2, 3, 6},
      {2, 4, 5},
      {2, 4, 6},
    ]
  end

  test "permutations" do
    assert Combinatoric.permutations({1, 2, 3}) == [
      {1, 2, 3},
      {1, 3, 2},
      {2, 1, 3},
      {2, 3, 1},
      {3, 1, 2},
      {3, 2, 1},
    ]
  end

  test "combinations" do
    assert Combinatoric.combinations({1, 2, 3, 4}, 2) == [
      {1, 2},
      {1, 3},
      {1, 4},
      {2, 3},
      {2, 4},
      {3, 4},
    ]
  end
end
