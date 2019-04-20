defmodule Hackerrank.BitterChocolate do

  @initial %{{1, 0, 0} => false}

  def compare(l = {l1, l2, l3}, r = {r1, r2, r3}) do
    sl = l1 + l2 + l3
    sr = r1 + r2 + r3
    cond do
      sl < sr -> true
      sl == sr -> l < r
      sl > sr -> false
    end
  end

  def grow_chocolate(r1, r2, r3) do
    for(
      a <- 1..r1,
      b <- 0..min(r2, a),
      c <- 0..min(r3, b),
      {a, b, c} != {1, 0, 0}
    ) do
      {a, b, c}
    end
    |> Enum.sort(&compare/2)
  end

  def fill(r1, r2, r3) do
    grow_chocolate(r1, r2, r3)
    |> Enum.reduce(@initial, &update_canwin_table/2)
  end

  def update_canwin_table(k = {a, b, c}, canwin_table) do
    good_move? = fn move, _ ->
      case Map.fetch(canwin_table, move) do
        {:ok, true} -> {:cont, false}
        {:ok, false} -> {:halt, true}
      end
    end

    can_win? =
      for(
        x <- a..1,
        y <- 3..1,
        case y do
          1 -> x <= a
          2 -> x <= b
          3 -> x <= c
        end,
        {x, y} != {1, 1}
      ) do
        bite = x - 1
        s = min(b, bite)
        t = min(c, bite)
        case y do
          1 -> {bite, s, t}
          2 -> {a, bite, t}
          3 -> {a, b, bite}
        end
      end
      |> Enum.reduce_while(false, good_move?)

    Map.put(canwin_table, k, can_win?)
  end

  def main do
    canwin_table = fill(25, 25, 25)
    IO.read(:line)

    cnc = fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> check(canwin_table)
    end

    IO.read(:all)
    |> String.split("\n", trim: true)
    |> Enum.map(cnc)
    |> Enum.join("\n")
    |> IO.write()
  end

  def check([a, b, c], canwin) do
    case canwin[{a, b, c}] do
      true -> "WIN"
      false -> "LOSE"
    end
  end

end
