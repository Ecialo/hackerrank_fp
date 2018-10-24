defmodule Hackerrank.ReverseAList do

  def main do
    IO.read(:all)
    |> String.split
    |> Enum.reverse
    |> Enum.join("\n")
    |> IO.write
  end

end
