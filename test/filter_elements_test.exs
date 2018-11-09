defmodule FilterElementsTest do
  use ExUnit.Case

  test "[4, 5, 2, 5, 4, 3, 1, 3, 4]" do
    assert Hackerranck.FilterElements.filter(
      [4, 5, 2, 5, 4, 3, 1, 3, 4],
      2
    ) == [4, 5, 3]
  end

  test "[4, 5, 2, 5, 4, 3, 1, 3, 4] 11" do
    assert Hackerranck.FilterElements.filter(
      [4, 5, 2, 5, 4, 3, 1, 3, 4],
      11
    ) == [-1]
  end
end
