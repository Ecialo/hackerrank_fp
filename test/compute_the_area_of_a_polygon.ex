defmodule ComputeTheAreaOfAPolygonTest do
  use ExUnit.Case
  alias Hackerrank.ComputeTheAreaOfAPolygon, as: Area

  test "quare" do
    points = [
      [0, 0],
      [0, 1],
      [1, 1],
      [1, 0]
    ]
    computed = Area.compute_area(points) |> Float.round(1)
    expected = 1
    assert(
      abs(computed - expected) < 0.01,
      "Expect #{expected}, got #{computed}"
    )
  end

end
