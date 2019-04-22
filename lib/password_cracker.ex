defmodule Hackerrank.PasswordCracker do

  alias Hackerrank.Candybox.{PrefixTree, Memo}

  @err_msg "WRONG PASSWORD"

  @spec make_password_prefix_tree([binary()]) :: PrefixTree.t()
  def make_password_prefix_tree(passwords) do
    Enum.reduce(passwords, PrefixTree.new(), fn password, ptree -> PrefixTree.add_string(ptree, password) end)
  end


  @spec check_password(Hackerrank.Candybox.PrefixTree.t(), binary()) :: binary()
  def check_password(ptree, password) do
    check_password(ptree, password, ptree, [""])
  end

  def check_password(
    _ptree,
    "",
    %PrefixTree{terminal: ter},
    [b | t]
  ) do
    if ter do
      all_passwords = Enum.reverse([String.reverse(b) | t])
      Enum.join(all_passwords, " ")
    else
      @err_msg
    end
  end

  def check_password(
    ptree,
    s = <<h::binary-size(1), rest::binary>>,
    cur_ptree = %PrefixTree{terminal: ter},
    [b | t]
    ) do

    k = {ptree, cur_ptree, s}
    case Memo.retrieve(k) do
      nil ->
        extend_case =
          case PrefixTree.move(cur_ptree, h) do
            {:ok, new_cur_ptree} -> # Can extend current password
              check_password(ptree, rest, new_cur_ptree, [h <> b | t])
            :error -> @err_msg
          end

        result =
          if extend_case == @err_msg and ter do
            case PrefixTree.move(ptree, h) do
              {:ok, new_cur_ptree} -> # brand new password
                password = String.reverse(b)  # the old one a complete one, but back to front
                check_password(ptree, rest, new_cur_ptree, [h, password | t])
              :error -> @err_msg  # We fucked
            end
          else
            extend_case
          end
        Memo.update(k, result)
        result

      result -> result
    end
  end


  def main do
    Memo.start_link(:ok)

    IO.read(:line)
    |> String.trim()
    |> String.to_integer()
    |> check([])
    |> Enum.join("\n")
    |> IO.write()
  end

  def check(0, acc), do: Enum.reverse(acc)
  def check(n, acc) do
    IO.read(:line)
    passwords = String.trim(IO.read(:line))
    password = String.trim(IO.read(:line))

    check_result =
      passwords
      |> String.split()
      |> make_password_prefix_tree()
      |> check_password(password)

    check(n - 1, [check_result | acc])
  end
end
