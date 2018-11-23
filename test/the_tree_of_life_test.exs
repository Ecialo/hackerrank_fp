defmodule TheTreeOfLifeTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias Hackerrank.TheTreeOfLife
  alias Hackerrank.TheTreeOfLife.{Tree, State}

  test "construct rule" do
    rule = TheTreeOfLife.construct_rule(42354)
    assert rule["1111"] == "1"
    assert rule["0111"] == "0"
  end

  test "parse simple tree" do
    tree = Tree.parse_tree("(X . .)")
    assert tree.left.val == "1"
    assert tree.right.val == "0"
  end

  test "parse complex tree" do
    tree = Tree.parse_tree("(X . (X . .))")
    # IO.inspect(tree)
    assert tree.left.val == "1"
    assert tree.right.val == "0"
    assert tree.right.left.val == "1"
  end

  test "apply rule" do
    rule = TheTreeOfLife.construct_rule(42354)
    tree = Tree.parse_tree("((. X (. . .)) . (X . (. X X)))")
    State.apply_rule(tree, rule)
  end

  test "sample" do
    sample_input = """
    42354
    ((. X (. . .)) . (X . (. X X)))
    6
    0 []
    2 [><]
    0 [><]
    0 [<>]
    1 [><]
    0 [<>]
    """
    expected_output = ".\nX\nX\n.\nX\nX"
    assert capture_io(sample_input, &TheTreeOfLife.main/0) == expected_output
  end

end
