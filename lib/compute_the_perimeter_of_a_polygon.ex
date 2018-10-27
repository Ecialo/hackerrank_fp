defmodule Hackerrank.ComputeThePerimeterOfAPolygon do
  def main do
    IO.read(:line)
    IO.read(:all)
      |> String.trim
      |> String.split("\n")
      |> Enum.map(
        fn p -> p |> String.split |> Enum.map(&String.to_integer/1) end
        )
      |> compute_perimeter
      |> Float.round(1)
      |> IO.write
  end

  def compute_perimeter(points) do
    compute_perimeter(points, {nil, nil, 0})
  end

  def compute_perimeter([h | t], {nil, _, 0}) do
    compute_perimeter(t, {h, h, 0})
  end

  def compute_perimeter([], {f_p, p_p, acc}) do
    acc + distance(f_p, p_p)
  end

  def compute_perimeter([h | t], {f_p, p_p, acc}) do
    compute_perimeter(t, {f_p, h, acc + distance(h, p_p)})
  end

  def distance([x0, y0], [x1, y1]) do
    dx = x0 - x1
    dy = y0 - y1
    :math.sqrt(dx*dx + dy*dy)
  end

end
