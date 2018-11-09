defmodule FilterElementsTest do
  use ExUnit.Case

  test "[4, 5, 2, 5, 4, 3, 1, 3, 4]" do
    assert Hackerrank.FilterElements.filter([4, 5, 2, 5, 4, 3, 1, 3, 4], 2)
      == [4, 5, 3]
  end
end
