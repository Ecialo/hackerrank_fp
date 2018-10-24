defmodule Hackerrank.ArrayOfNElements do
  def main do
    IO.read(:line)
      |> String.trim
      |> String.to_integer
      |> new_range
      |> format
      |> IO.write
  end

  def new_range(0) do
    []
  end

  def new_range(num) when is_number(num) do
    Range.new(0, num - 1) |> Enum.to_list
  end

  def format(data) do
    data = data |> Enum.map(&Integer.to_string/1) |> Enum.join(", ")
    "[#{data}]"
  end

end
