defmodule FilterPositionsInAListTest do
  use ExUnit.Case

  test "[4, 3, 2, 1, 5, 6]" do
    assert Hackerrank.FilterPositionsInAList.filter([4, 3, 2, 1, 5, 6])
      == [3, 1, 6]
  end
end
