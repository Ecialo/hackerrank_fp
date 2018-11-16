defmodule Hackerrank.SequenceFullOfColors do

  def main do
    IO.read(:line)
    IO.read(:all)
      |> String.split("\n")
      |> Enum.map(
          fn x ->
            String.to_charlist(x)
              |> Enum.reduce_while({0, 0, 0, 0}, &check/2)
              |> final_check()
          end
         )
      |> Enum.join("\n")
      |> IO.write()
  end

  def check(?R, {r, g, y, b}) when abs(r + 1 - g) <= 1 do
      {:cont, {r + 1, g, y, b}}
  end

  def check(?G, {r, g, y, b}) when abs(g + 1 - r) <= 1 do
      {:cont, {r, g + 1, y, b}}
  end

  def check(?Y, {r, g, y, b}) when abs(y + 1 - b) <= 1 do
      {:cont, {r, g, y + 1, b}}
  end

  def check(?B, {r, g, y, b}) when abs(b + 1 - y) <= 1 do
      {:cont, {r, g, y, b + 1}}
  end

  def check(_, _) do
    {:halt, "False"}
  end

  def final_check("False") do
    "False"
  end

  def final_check({r, g, y, b}) do
    if r == g
       and y == b
       and abs(r - g) <= 1
       and abs(y - b) <= 1
    do
      "True"
    else
      "False"
    end
  end

end
