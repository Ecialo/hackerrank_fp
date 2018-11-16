defmodule Hackerrank.Fibonacci.State do
  use Agent

  def start_link() do
    Agent.start_link(fn -> %{1 => 1, 0 => 0} end, name: __MODULE__)
  end

  def compute(x) when is_integer(x) do
    with {:ok, fib} <- Agent.get(__MODULE__, &Map.fetch(&1, x)) do
      fib
    else
      :error ->
        Agent.update(__MODULE__, &fill(&1, x))
        compute(x)
    end
  end

  def fill(state, x) do
    with {:ok, pfib} <- Map.fetch(state, x - 1),
         {:ok, ppfib} <- Map.fetch(state, x - 2)
    do
      Map.put(state, x, pfib + ppfib)
    else
      :error -> fill(fill(state, x - 1), x)
    end
  end

end

defmodule Hackerrank.Fibonacci do
  alias Hackerrank.Fibonacci.State

  @mod 100_000_000 + 7

  def main do
    State.start_link()
    IO.read(:line)
    IO.read(:all)
      |> String.split("\n")
      |> Enum.map(
          fn x ->
            x |> String.to_integer() |> State.compute() |> rem(@mod)
          end
         )
      |> Enum.join("\n")
      |> IO.write()
  end
end
