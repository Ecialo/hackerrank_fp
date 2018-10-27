defmodule Hackerrank.AreaAndVolumeOfCurve do

  alias Hackerrank.Candybox.Integral

  def main do
    c = IO.read(:line) |> String.split |> Enum.map(&String.to_integer/1)
    p = IO.read(:line) |> String.split |> Enum.map(&String.to_integer/1)
    [l, r] = IO.read(:line) |> String.split |> Enum.map(&String.to_integer/1)
    f = construct_function(c, p)
    [compute_area(f, l, r), compute_volume(f, l, r)]
      |> Enum.map(fn x -> Float.round(x, 1) |> Float.to_string end)
      |> Enum.join("\n")
      |> IO.write
  end

  def construct_function(coefs, powers) do
    fn x -> Enum.reduce(
      Enum.zip(coefs, powers),
      0,
      fn {c, p}, acc -> acc + c*:math.pow(x, p) end
    ) end
  end

  def compute_area(f, l, r) do
    Integral.rectangle_rule(f, l, r, 0.001)
  end

  def compute_volume(f, l, r) do
    :math.pi * Integral.rectangle_rule(
      fn x -> :math.pow(f.(x), 2) end,
      l, r, 0.001)
  end

end
