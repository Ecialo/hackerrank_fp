defmodule ComputeThePerimeterOfAPolygonTest do
  use ExUnit.Case
  alias Hackerrank.ComputeThePerimeterOfAPolygon, as: Perimeter

  test "quare" do
    points = [
      [0, 0],
      [0, 1],
      [1, 1],
      [1, 0]
    ]
    computed = Perimeter.compute_perimeter(points) |> Float.round(1)
    expected = 4
    assert(
      abs(computed - expected) < 0.01,
      "Expect #{expected}, got #{computed}"
    )
  end

end
