defmodule HackerrankTest do
  use ExUnit.Case
  doctest Hackerrank

  test "greets the world" do
    assert Hackerrank.hello() == :world
  end
end
