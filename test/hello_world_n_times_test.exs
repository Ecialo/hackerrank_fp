defmodule HelloWorldNTimesTest do
  use ExUnit.Case

  test "A 3 times" do
    assert Hakerrank.HelloWorldNTimes.join("A", 3) == "A\nA\nA"
  end
end
