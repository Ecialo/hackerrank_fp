defmodule PrefixCompressionTest do
  use ExUnit.Case

  test "abcdefpr abcpqr" do
    a = "abcdefpr"
    b = "abcpqr"
    assert Hackerrank.PrefixCompression.compress_prefix(a, b) == [
      {3, "abc"},
      {5, "defpr"},
      {3, "pqr"}
    ]
  end

  test "empty" do
    a = ""
    b = ""
    assert Hackerrank.PrefixCompression.compress_prefix(a, b) == [
      {0, ""},
      {0, ""},
      {0, ""}
    ]
  end

  test "kitkat kit" do
    a = "kitkat"
    b = "kit"
    assert Hackerrank.PrefixCompression.compress_prefix(a, b) == [
      {3, "kit"},
      {3, "kat"},
      {0, ""}
    ]
  end
end
