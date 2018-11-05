defmodule Hackerrank.SimplifyTheAlgebraicExpressions.Term do
  alias __MODULE__

  defstruct [data: %{}]

  def new(data) when is_map(data) do
    %Term{data: data}
  end

  def new(term_string) when is_binary(term_string) do
    {integer, power} = case Integer.parse(term_string) do
      {integer, power} -> {integer, power}
      :error -> {1, "x"}
    end
    case power do
      "x" -> %Term{data: %{1 => integer}}
      "" -> %Term{data: %{0 => integer}}
    end
  end

  def unikeys(%Term{data: data_a}, %Term{data: data_b}) do
    [Map.keys(data_a), Map.keys(data_b)]
      |> Enum.concat()
      |> Enum.uniq()
  end

  def repr(%Term{data: data}) do
    data
      |> Enum.sort()
      |> Enum.map(
          fn {p, c} ->
            c = trunc(c)
            case {c, p} do
              {0, _} -> nil
              {c, 0} -> "#{c}"
              {1, 1} -> "x"
              {-1, 1} -> "-x"
              {1, p} -> "x^#{p}"
              {-1, p} -> "-x^#{p}"
              {c, 1} -> "#{c}x"
              {c, p} -> "#{c}x^#{p}"
            end
          end
         )
      |> Enum.filter(&(&1))
      |> Enum.reverse()
      |> Enum.join(" + ")
      |> String.replace("+ -", "- ")
  end

  def add(term_a = %Term{data: data_a}, term_b = %Term{data: data_b}) do
    for key <- unikeys(term_a, term_b), into: %{} do
      va = Map.get(data_a, key, 0)
      vb = Map.get(data_b, key, 0)
      {key, va + vb}
    end
      |> new()
  end

  def sub(term_a = %Term{data: data_a}, term_b = %Term{data: data_b}) do
    for key <- unikeys(term_a, term_b), into: %{} do
      va = Map.get(data_a, key, 0)
      vb = Map.get(data_b, key, 0)
      {key, va - vb}
    end
      |> new()
  end

  def mul(%Term{data: data_a}, %Term{data: data_b}) do
    for key_a <- Map.keys(data_a), key_b <- Map.keys(data_b) do
      {key_a + key_b, data_a[key_a]*data_b[key_b]}
    end
      |> Enum.reduce(
          %{},
          fn {k, v}, acc -> Map.put(acc, k, Map.get(acc, k, 0) + v) end
        )
      |> new()
  end

  def div_(%Term{data: data_a}, %Term{data: data_b}) do
    divisor = data_b[0]
    data_a
      |> Enum.map(fn {k, v} -> {k, v/divisor} end)
      |> Enum.into(%{})
      |> new()
  end

  def pow(%Term{data: data_a}, %Term{data: data_b}) do
    power = data_b[0]
    data_a
      |> Enum.map(fn {k, v} -> {k + power - 1 , v} end)
      |> Enum.into(%{})
      |> new()
  end

  def call(term_a, op, term_b) do
    case op do
      "+" -> add(term_a, term_b)
      "-" -> sub(term_a, term_b)
      "*" -> mul(term_a, term_b)
      "/" -> div_(term_a, term_b)
      "^" -> pow(term_a, term_b)
    end
  end

end

defmodule Hackerrank.SimplifyTheAlgebraicExpressions do

  alias Hackerrank.SimplifyTheAlgebraicExpressions.Term

  @op_priority %{
    "^" => 5,
    "*" => 4,
    "/" => 4,
    "+" => 3,
    "-" => 3,
  }

  @right_associative ["^"]

  defguard is_part_of_term(x) when x in ~w"0 1 2 3 4 5 6 7 8 9 x"
  defguard is_op(x) when x in ~w"+ - * / ^"
  defguard is_bracket(x) when x in ~w"( )"

  def main do
    IO.read(:line)
    IO.read(:all)
      |> String.split("\n", trim: true)
      |> Enum.map(&main/1)
      |> Enum.join("\n")
      |> IO.write()
  end

  def main(expr) do
    expr
      |> String.trim()
      |> tokenize()
      |> expose_mul()
      |> remove_uno()
      |> inf2post()
      |> compute()
      |> Term.repr()
  end

  def tokenize(string) do
    parse(string, [])
  end

  def parse("", tokens) do
    Enum.reverse(tokens)
  end

  def parse(
    <<h::binary-size(1), t::binary>>,
    tokens
  ) when is_op(h) or is_bracket(h) do
    parse(t, [h | tokens])
  end

  def parse(
    <<" "::utf8, t::binary>>,
    tokens
  ) do
    parse(t, tokens)
  end

  def parse(
    string = <<h::binary-size(1), _::binary>>,
    tokens
  ) when is_part_of_term(h) do
    {term, rest} = parse_term(string, [])
    parse(rest, [term | tokens])
  end

  def parse_term("", acc) do
    term = acc |> Enum.reverse() |> List.to_string()
    {term, ""}
  end

  def parse_term(
    <<h::binary-size(1), t::binary>>,
    acc
  ) when is_part_of_term(h) do
    parse_term(t, [h | acc])
  end

  def parse_term(
    string = <<h::binary-size(1), _::binary>>,
    acc
  ) when not is_part_of_term(h) do
    term = acc |> Enum.reverse() |> List.to_string()
    {term, string}
  end

  def expose_mul(tokens) do
    expose_mul(tokens, [])
  end

  def expose_mul([], output) do
    Enum.reverse(output)
  end

  def expose_mul(
    [term, "(" | tokens],
    output
  ) when not is_op(term) and not is_bracket(term) do
    expose_mul([term, "*", "(" | tokens], output)
  end

  def expose_mul([h | t], output) do
    expose_mul(t, [h | output])
  end

  def remove_uno(tokens) do
    ["0", "+" | tokens]
      |> remove_uno([])
      |> Enum.reverse()
  end

  def remove_uno([], output) do
    output
  end

  def remove_uno(["+", "-" | tokens], output) do
    remove_uno(["-" | tokens], output)
  end

  def remove_uno(["-", "-" | tokens], output) do
    remove_uno(["+" | tokens], output)
  end

  def remove_uno(["*", "-" | tokens], output) do
    remove_uno(["*", "-1", "*" | tokens], output)
  end

  def remove_uno(["/", "-" | tokens], output) do
    remove_uno(["/", "-1", "/" | tokens], output)
  end

  def remove_uno([h | tokens], output) do
    remove_uno(tokens, [h | output])
  end

  def inf2post(tokens) do
    inf2post(tokens, [], [])
  end

  def inf2post([], [], output) do
    Enum.reverse(output)
  end

  def inf2post([], [h | t], output) do
    inf2post([], t, [h | output])
  end

  def inf2post([h = "(" | t], stack, output) do
      inf2post(t, [h | stack], output)
  end

  def inf2post([")" | t_t], ["(" | s_t], output) do
    inf2post(t_t, s_t, output)
  end

  def inf2post(tokens = [")" | _], [s_h | s_t], output) do
    inf2post(tokens, s_t, [s_h | output])
  end

  def inf2post(
    tokens = [h | t],
    stack = [s_h | s_t],
    output
  ) when is_op(h) and is_op(s_h) do
    tok_p = @op_priority[h]
    sta_p = @op_priority[s_h]
    cond do
      h in @right_associative and tok_p < sta_p ->
        inf2post(tokens, s_t, [s_h | output])
      h not in @right_associative and tok_p <= sta_p ->
        inf2post(tokens, s_t, [s_h | output])
      true ->
        inf2post(t, [h | stack], output)
    end
  end

  def inf2post([h | t], stack = ["(" | _], output) when is_op(h) do
    inf2post(t, [h | stack], output)
  end

  def inf2post([h | t], stack = [], output) when is_op(h) do
    inf2post(t, [h | stack], output)
  end

  def inf2post([h | t], stack, output) when not is_op(h) do
    inf2post(t, stack, [h | output])
  end

  def compute(terms) do
    compute(terms, [])
  end

  def compute([], [h]) do
    h
  end

  def compute([h | t], [r, l | s_t]) when is_op(h) do
    n = Term.call(l, h, r)
    compute(t, [n | s_t])
  end

  def compute([h | t], stack) do
    n = Term.new(h)
    compute(t, [n | stack])
  end

end
