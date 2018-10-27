defmodule AreaAndVolumeOfCurveTest do
  use ExUnit.Case
  alias Hackerrank.AreaAndVolumeOfCurve
  alias Hackerrank.Candybox.Integral

  test "area 1..10" do
    c = [1, 2, 3, 4, 5]
    p = [6, 7, 8, 9, 10]
    f = AreaAndVolumeOfCurve.construct_function(c, p)
    computed = Float.round(Integral.rectangle_rule(f, 1, 4, 0.001), 1)
    expected = 2435300.3
    assert(
      abs(computed - expected) < 0.01,
      "Expect #{expected}, got #{computed}"
    )
  end


end
