defmodule ListReplicationTest do
  use ExUnit.Case

  test "[1, 2, 3] 2 times" do
    assert Hackerrank.ListReplication.replicate([1, 2, 3], 2)
      == [1, 1, 2, 2, 3, 3]
  end
end
