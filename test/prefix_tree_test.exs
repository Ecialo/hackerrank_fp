defmodule PrefixTreeTest do
  use ExUnit.Case
  alias Hackerrank.Candybox.PrefixTree, as: PTree

  test "add new elem" do
    new_ptree = PTree.new()
    uptree = PTree.add_elem(new_ptree, "a", true)
    assert uptree == %PTree{transitions: %{"a" => %PTree{terminal: true}}}
  end

  test "update elem" do
    new_ptree = %PTree{transitions: %{"a" => PTree.new()}}
    uptree = PTree.add_elem(new_ptree, "a", true)
    assert uptree == %PTree{transitions: %{"a" => %PTree{terminal: true}}}
  end

  test "add string" do
    ptree = PTree.add_string(PTree.new(), "lol")
    res = with(
      {:ok, l_node} <- PTree.move(ptree, "l"),
      {:ok, o_node} <- PTree.move(l_node, "o"),
      {:ok, one_more_l} <- PTree.move(o_node, "l")
    ) do
      one_more_l
    else
      :error -> :error
    end

    assert res == %PTree{terminal: true}
  end

  test "multi add" do
    ptree =
      PTree.new()
      |> PTree.add_string("lol")
      |> PTree.add_string("lul")

    resol = with(
      {:ok, l_node} <- PTree.move(ptree, "l"),
      {:ok, o_node} <- PTree.move(l_node, "o"),
      {:ok, one_more_l} <- PTree.move(o_node, "l")
    ) do
      one_more_l
    else
      :error -> :error
    end

    resul = with(
      {:ok, l_node} <- PTree.move(ptree, "l"),
      {:ok, u_node} <- PTree.move(l_node, "u"),
      {:ok, one_more_l} <- PTree.move(u_node, "l")
    ) do
      one_more_l
    else
      :error -> :error
    end

    resal = with(
      {:ok, l_node} <- PTree.move(ptree, "l"),
      {:ok, a_node} <- PTree.move(l_node, "a"),
      {:ok, one_more_l} <- PTree.move(a_node, "l")
    ) do
      one_more_l
    else
      :error -> :error
    end

    assert resol == %PTree{terminal: true}
    assert resul == %PTree{terminal: true}
    assert resal == :error
  end
end
