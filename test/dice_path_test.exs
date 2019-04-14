defmodule DicePathTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias Hackerrank.DicePath.Field

  # setup_all do
  #   {:ok, %{field_server: Field.start_link({3, 3})}}
  # end

  test "sample 1" do
    initial = Field.default_start
    initial = Field.fill(initial, {2, 1}, {3, 3})
    {i_points, _} = initial[{1, 1}]
    assert i_points == 1
    {i_points, _} = initial[{2, 2}]
    assert i_points == 9
    {i_points, _} = initial[{1, 2}]
    assert i_points == 6
    {i_points, _} = initial[{2, 1}]
    assert i_points == 4
    {i_points, _} = initial[{3, 3}]
    assert i_points == 19
  end

  test "as server" do
    {:ok, p} = Field.start_link({60, 60})
    points = Field.find_max_path({3, 3})
    assert points == 19
    Field.stop()
  end

  test "main" do
    inpt = """
    4
    2 2
    1 2
    2 1
    3 3
    """
    outpt = String.trim("""
    9
    4
    6
    19
    """, "\n")
    assert capture_io(inpt, &Hackerrank.DicePath.main/0) == outpt
  end
end

