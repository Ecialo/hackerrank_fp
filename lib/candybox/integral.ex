defmodule Hackerrank.Candybox.Integral do

  defguard calculable(func, left, right) when
    is_function(func, 1)
    and is_number(left)
    and is_number(right)
    and left <= right

  def rectangle_rule(f, l, r, d) when calculable(f, l, r) and is_float(d) do
    n = trunc((r - l)/d)
    Enum.reduce(0..n, 0, fn x, acc -> acc + f.(l + d*x) end)
      |> :erlang.*(d)
  end
end
