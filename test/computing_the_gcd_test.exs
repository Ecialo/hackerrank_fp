defmodule ComputingTheGCDTest do
  use ExUnit.Case

  test "10, 45" do
    assert Hackerrank.ComputingTheGCD.gcd(10, 45) == 5
  end

  test "1701, 3768" do
    assert Hackerrank.ComputingTheGCD.gcd(1701, 3768) == 3
  end
end
