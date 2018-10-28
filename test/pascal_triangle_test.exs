defmodule PascalTriangeTest do
  use ExUnit.Case
  alias Hackerrank.PascalTriangle

  setup_all do
    PascalTriangle.init
    {:ok, %{}}
  end

  test "line 1" do
    assert PascalTriangle.make_line(0) == [1]
  end

  test "line 2" do
    assert PascalTriangle.make_line(1) == [1, 1]
  end

end
