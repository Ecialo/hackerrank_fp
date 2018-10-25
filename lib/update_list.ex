defmodule Hackerrank.UpdateList do
  def main do
    IO.read(:all)
      |> String.split
      |> Enum.map(&String.to_integer/1)
      |> Enum.map(&abs/1)
      |> Enum.map(&Integer.to_string/1)
      |> Enum.join("\n")
      |> IO.write
  end
end
