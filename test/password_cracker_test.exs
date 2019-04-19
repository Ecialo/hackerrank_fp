defmodule PasswordCrackerTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias Hackerrank.PasswordCracker

  test "we do what we must because we can" do
    ptree = PasswordCracker.make_password_prefix_tree(~w"because can do must we what")
    res = PasswordCracker.check_password(ptree, "wedowhatwemustbecausewecan")
    assumed = "we do what we must because we can"

    assert res == assumed
  end

  test "hello world" do
    ptree = PasswordCracker.make_password_prefix_tree(~w"hello planet")
    res = PasswordCracker.check_password(ptree, "helloworld")
    assumed = "WRONG PASSWORD"

    assert res == assumed
  end

  test "full sample 1" do
    input = """
    3
    4
    ozkxyhkcst xvglh hpdnb zfzahm
    zfzahm
    4
    gurwgrb maqz holpkhqx aowypvopu
    gurwgrb
    10
    a aa aaa aaaa aaaaa aaaaaa aaaaaaa aaaaaaaa aaaaaaaaa aaaaaaaaaa
    aaaaaaaaaab
    """
    output = "zfzahm\ngurwgrb\nWRONG PASSWORD"

    assert capture_io(input, &PasswordCracker.main/0) == output
  end

end
