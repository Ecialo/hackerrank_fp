defmodule Hackerrank.PascalTriangle do

  alias Hackerrank.Candybox.Factorial

  def main do
    init()
    IO.read(:line)
      |> String.trim
      |> String.to_integer
      |> make_triangle
      |> Enum.map(fn line -> line
                              |> Enum.map(&Integer.to_string/1)
                              |> Enum.join(" ") end)
      |> Enum.join("\n")
      |> IO.write
  end

  def init do
    Factorial.start_link
  end

  def make_triangle(lines) do
    for i <- 0..(lines - 1) do
      make_line(i)
    end
  end

  def make_line(n) do
    for r <- 0..n do
      Factorial.compute(n)/(Factorial.compute(r) * Factorial.compute(n - r))
        |> trunc
    end
  end

end
