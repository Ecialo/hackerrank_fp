defmodule Hackerrank.ComputeTheAreaOfAPolygon do
  def main do
    IO.read(:line)
    IO.read(:all)
      |> String.trim
      |> String.split("\n")
      |> Enum.map(
        fn p -> p |> String.split |> Enum.map(&String.to_integer/1) end
        )
      |> compute_area
      |> Float.round(1)
      |> IO.write
  end

  def compute_area(points) do
    compute_area(points, {nil, nil, 0}) / 2
  end

  def compute_area([h | t], {nil, _, 0}) do
    compute_area(t, {h, h, 0})
  end

  def compute_area([], {f_p, p_p, acc}) do
    acc + sub_area(f_p, p_p)
  end

  def compute_area([h | t], {f_p, p_p, acc}) do
    compute_area(t, {f_p, h, acc + sub_area(h, p_p)})
  end

  def sub_area([x0, y0], [x1, y1]) do
    s1 = x1 * y0
    s2 = x0 * y1
    s1 - s2
  end

end
