defmodule Hackerrank.HelloWorldNTimes do
  def main do
    IO.read(:line)
      |> String.trim()
      |> String.to_integer()
      |> join("Hello World")
      |> IO.write()
  end

  def join(s, times) when is_binary(s) do
    List.duplicate(s, times) |> Enum.join("\n")
  end

  def join(times, s) when is_number(times) do
    join(s, times)
  end
end
