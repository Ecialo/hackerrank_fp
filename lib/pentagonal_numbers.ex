defmodule Hackerrank.PentagonalNumbers.State do
  use Agent

  def start_link() do
    Agent.start_link(fn -> %{1 => 1} end, name: __MODULE__)
  end

  def compute(x) when is_integer(x) do
    with {:ok, pent} <- Agent.get(__MODULE__, &Map.fetch(&1, x)) do
      pent
    else
      :error ->
        prev_pent = compute(x - 1)
        Agent.update(__MODULE__, &Map.put(&1, x, 2*x + (x - 2) + prev_pent))
        compute(x)
    end
  end

end

defmodule Hackerrank.PentagonalNumbers do
  alias Hackerrank.PentagonalNumbers.State
  def main do
    State.start_link()
    IO.read(:line)
    IO.read(:all)
      |> String.split("\n")
      |> Enum.map(fn x -> x |> String.to_integer() |> State.compute() end)
      |> Enum.join("\n")
      |> IO.write()
  end
end
