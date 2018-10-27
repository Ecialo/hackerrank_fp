defmodule Hackerrank.FunctionsOrNot do

  def main do
    IO.read(:line)
      |> String.trim
      |> String.to_integer
      |> process_cases
      |> Enum.join("\n")
      |> IO.write
  end

  def process_cases(0) do
    []
  end

  def process_cases(times) do
    case_ans = IO.read(:line)
      |> String.trim
      |> String.to_integer
      |> process_case
      |> List.wrap
    [case_ans | process_cases(times - 1)]
  end

  def process_case(num_lines) do
    process_case(num_lines, %{})
  end

  def process_case(0, %{}) do
    "YES"
  end

  def process_case(num_lines, acc = %{}) do
    [k, v] = IO.read(:line) |> String.split
    with {:ok, sv} <- Map.fetch(acc, k),
         false <- sv == v do
      process_case(num_lines - 1, "NO")
    else
      _ -> process_case(num_lines - 1, Map.put(acc, k, v))
    end
  end

  def process_case(0, "NO") do
    "NO"
  end

  def process_case(num_lines, "NO") do
    IO.read(:line)
    process_case(num_lines - 1, "NO")
  end

end
