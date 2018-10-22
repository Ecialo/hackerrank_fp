defmodule HakerrankTest do
  use ExUnit.Case
  doctest Hakerrank

  test "greets the world" do
    assert Hakerrank.hello() == :world
  end
end
