defmodule SumOfOddElementsTest do
  use ExUnit.Case

  test "[4, 3, 2, 1, 5, 6] less then 4" do
    assert Hackerrank.SumOfOddElements.sum([4, 3, 2, 1, 5, 6]) == (3 + 1 + 5)
  end
end
