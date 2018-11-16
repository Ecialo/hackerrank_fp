defmodule Hackerrank.RotateString do

  def main do
    IO.read(:line)
    IO.read(:all)
      |> String.split("\n")
      |> Enum.map(&rotate/1)
      |> Enum.join("\n")
      |> IO.write()
  end

  def rotate(s) do
    l = String.length(s)
    <<_::binary-size(1), t::binary>> = s<>s
    rotate(t, l, l, [])
  end

  def rotate(_, _, 0, acc) do
    acc |> Enum.reverse() |> Enum.join(" ")
  end

  def rotate(s = <<_::binary-size(1), t::binary>>, len, times, acc) do
    rotate(t, len, times - 1, [String.slice(s, 0, len) | acc])
  end

end
