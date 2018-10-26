defmodule Hackerrank.Candybox.Factorial do
  use Agent

  def start_link() do
    Agent.start_link(fn -> %{0 => 1} end, name: __MODULE__)
  end

  def compute(x) when is_integer(x) do
    with {:ok, factorial} <- Agent.get(__MODULE__, &Map.fetch(&1, x)) do
      factorial
    else
      :error ->
        prev_factorial = compute(x - 1)
        Agent.update(__MODULE__, &Map.put(&1, x, x*prev_factorial))
        compute(x)
    end
  end

end
