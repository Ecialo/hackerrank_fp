defmodule Hackerrank.StringCompression do

  def main do
    IO.read(:line)
      |> String.trim()
      |> compress()
      |> IO.write()
  end

  def compress(string) when is_binary(string) do
    string
      |> compress(nil, 0, [])
      |> Enum.reverse()
      |> List.to_string()
  end

  def compress(c) when is_integer(c) and c > 1 do
    to_string(c)
  end

  def compress(c) when is_integer(c) and c <= 1 do
    ""
  end

  def compress("", _, c, result) do
    [compress(c) | result]
  end

  def compress(<<h::utf8, t::binary>>, ch, c, result) when h == ch do
    compress(t, ch, c + 1, result)
  end

  def compress(<<h::utf8, t::binary>>, ch, c, result) when h != ch do
    compress(t, h, 1, [h, compress(c) | result])
  end

end
