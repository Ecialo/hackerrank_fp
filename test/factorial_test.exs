defmodule FactorialTest do
  use ExUnit.Case
  alias Hackerrank.Candybox.Factorial

  setup_all do
    {:ok, %{fact_agent: Factorial.start_link}}
  end

  test "fact 0" do
    assert Factorial.compute(0) == 1
  end

  test "fact 5" do
    assert Factorial.compute(5) == 120
  end

  test "fact 9" do
    assert Factorial.compute(9) == 362880
  end

  test "double call" do
    assert Factorial.compute(5) == 120
    assert Factorial.compute(5) == 120
  end

end
