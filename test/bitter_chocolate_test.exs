defmodule BitterChocolateTest do
  use ExUnit.Case

  alias Hackerrank.BitterChocolate

  test "sample" do

    canwin = BitterChocolate.fill(3, 3, 3)
    IO.inspect(canwin)
    assert canwin[{1, 1, 0}]
    assert not canwin[{2, 1, 0}]
    assert canwin[{1, 1, 1}]
    assert not canwin[{2, 2, 1}]
  end

  test "compare" do
    assert BitterChocolate.compare({2, 0, 0}, {1, 1, 1})
    assert not BitterChocolate.compare({1, 1, 1}, {2, 0, 0})
  end

  test "grow chocolate" do
    chocolate = BitterChocolate.grow_chocolate(3, 2, 1)

    assert chocolate == [
      # 2
      {1, 1, 0},
      {2, 0, 0},
      #3
      {1, 1, 1},
      {2, 1, 0},
      {3, 0, 0},
      # 4
      {2, 1, 1},
      {2, 2, 0},
      {3, 1, 0},
      # 5
      {2, 2, 1},
      {3, 1, 1},
      {3, 2, 0},
      # 6
      {3, 2, 1},
    ]
  end

end
