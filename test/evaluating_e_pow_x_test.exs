defmodule EvaluatingEPowXTest do
  use ExUnit.Case
  alias Hackerrank.EvaluatingEPowX

  setup_all do
    EvaluatingEPowX.init
    {:ok, %{}}
  end

  test "e**20.0000" do
    computed = EvaluatingEPowX.compute(20.0000)
    expected = 2423600.1887
    assert(
      abs(computed - expected) < 0.1,
      "Expect #{expected}, got #{computed}"
    )
  end

  test "e**5" do
    computed = EvaluatingEPowX.compute(5.0000)
    expected = 143.6895
    assert(
      abs(computed - expected) < 0.1,
      "Expect #{expected}, got #{computed}"
    )
  end

end
