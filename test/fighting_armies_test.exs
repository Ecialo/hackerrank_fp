defmodule FightingArmiesTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias Hackerrank.FightingArmies

  test "sample" do
    sample_input =
      """
      2 6
      3 1 10
      3 2 20
      4 1 2
      1 1
      2 1
      1 1\
      """
    sample_output = "20\n10"
    assert capture_io(sample_input, &FightingArmies.main/0) == sample_output
  end

  test "parse" do
    assert FightingArmies.parse("3 1 10") == [3, 1, 10]
  end

end
