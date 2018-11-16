defmodule Hackerrank.RemoveDuplicates do

  def main do
    IO.read(:line)
      |> String.trim()
      |> reduct()
      |> IO.write()
  end

  def reduct(string) do
    reduct(string, MapSet.new())
  end

  def reduct("", _) do
    ""
  end

  def reduct(<<h::utf8, t::binary>>, acc) do
    if h in acc do
      reduct(t, acc)
    else
      <<h::utf8, reduct(t, MapSet.put(acc, h))::binary>>
    end
  end

end
