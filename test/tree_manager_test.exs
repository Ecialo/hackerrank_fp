defmodule TreeManagerTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias Hackerrank.TreeManager
  alias Hackerrank.Tree.{Zipper, Node}

  test "update_parent" do
    zipper =
      Zipper.new()
      |> Map.put(:path, [{:parent, %Node{child: %Node{value: 100}}}])
      |> Map.put(:scope, %Node{value: 11})
      |> Zipper.update_parent()
    [{:parent, %Node{child: n}} | _] = zipper.path
    assert n.value == 11
  end

  test "visit parent and update" do
    zipper =
      Zipper.new()
      |> Map.put(:path, [{:parent, %Node{child: %Node{value: 100}}}])
      |> Map.put(:scope, %Node{value: 11})
      |> Zipper.visit(:parent)
    assert zipper.scope.child.value == 11
  end

  test "update child" do
    zipper = Zipper.new()
    new_zipper =
      zipper
      |> Zipper.insert(:child, 11)
      |> Zipper.visit(:child)
      |> Zipper.change_value(100)
      |> Zipper.visit(:parent)
      |> Zipper.visit(:child)
    assert new_zipper.scope.value == 100
  end

  @tag :complex
  test "hr sample" do
    commands = [
      ["change", "1"],
      ["print"],
      ["insert", "child", "2"],
      ["visit", "child", "1"],
      ["insert", "right", "3"],
      ["visit", "right"],
      ["print"],
      ["insert", "right", "4"],
      ["delete"],
      ["visit", "child", "2"],
      ["print"]
    ]
    zipper = Zipper.new()
    assert capture_io(fn -> TreeManager.execute_many(zipper, commands) end)
     == "1\n3\n4\n"
  end

  @tag :complex
  test "hr sample every step print" do
    commands = [
      ["change", "1"],
      ["print"], # 1
      ["insert", "child", "2"],
      ["visit", "child", "1"],
      ["print"], # 2
      ["insert", "right", "3"],
      ["visit", "right"],
      ["print"], # 3
      ["insert", "right", "4"],
      ["visit", "right"],
      ["print"], # 4
      ["visit", "left"],
      ["print"], # 3
      ["delete"],
      ["print"], # 1
      ["visit", "child", "1"],
      ["print"], # 2
      ["visit", "right"],
      ["print"] # 4
    ]
    zipper = Zipper.new()
    assert capture_io(fn -> TreeManager.execute_many(zipper, commands) end)
     == "1\n2\n3\n4\n3\n1\n2\n4\n"
  end

  @tag :complex
  test "tc 2" do
    commands = [
      ["change", "986807"],
      ["print"],
      ["change", "296567"],
      ["print"],
      ["change", "188703"],
      ["insert", "child", "662395"],
      ["visit", "child", "1"],
      ["insert", "left", "761328"],
      ["visit", "left"],
      ["print"],
      ["insert", "left", "955007"],
      ["delete"],
      ["visit", "child", "2"],
      ["visit", "left"],
      ["insert", "left", "495344"],
      ["print"],
      ["insert", "right", "571249"],
      ["visit", "right"],
      ["insert", "left", "592419"]
    ]
    zipper = Zipper.new()
    result = "986807\n296567\n761328\n955007\n"
    assert capture_io(fn -> TreeManager.execute_many(zipper, commands) end)
     == result
  end
end
