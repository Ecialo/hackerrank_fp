defmodule FilterArrayTest do
  use ExUnit.Case

  test "[4, 3, 2, 1, 5, 6] less then 4" do
    assert Hackerrank.FilterArray.filter([4, 3, 2, 1, 5, 6], 4) == [3, 2, 1]
  end
end
