defmodule Hackerrank.Infer.IdsProvider do
  use GenServer

  alias __MODULE__, as: IdsProvider

  def init(_) do
    {:ok, 0}
  end

  def start_link() do
    GenServer.start_link(IdsProvider, nil, name: IdsProvider)
  end

  def handle_call(:next, _from, id) do
    {:reply, id, id + 1}
  end

  def handle_call(:flush, _from, _id) do
    {:reply, :ik, 0}
  end

  def flush() do
    GenServer.call(IdsProvider, :flush)
  end

  def next_id() do
    GenServer.call(IdsProvider, :next)
  end
end

defmodule Hackerrank.Infer.CharsProvider do
  use GenServer

  alias __MODULE__, as: CharsProvider

  def init(_) do
    {:ok, {%{}, Enum.map(?a..?z, fn(x) -> <<x :: utf8>> end)}}
  end

  def start_link() do
    GenServer.start_link(CharsProvider, nil, name: CharsProvider)
  end

  def handle_call({:char, var}, _from, {m, all} = st) do
    case Map.get(m, var) do
      nil ->
        [nch | rest] = all
        nm = Map.put(m, var, nch)
        {:reply, nch, {nm, rest}}
      char ->
        {:reply, char, st}
    end
  end

  def handle_call(:all, _from, {m, _all} = st) do
    all_ch =
      m
      |> Map.values()
      |> Enum.sort()

    {:reply, all_ch, st}
  end

  def handle_call(:flush, _from, _id) do
    {:reply, :ok, {%{}, Enum.map(?a..?z, fn(x) -> <<x :: utf8>> end)}}
  end

  def flush() do
    GenServer.call(CharsProvider, :flush)
  end

  def get_char(var) do
    GenServer.call(CharsProvider, {:char, var})
  end

  def get_all_chars() do
    GenServer.call(CharsProvider, :all)
  end
end

defmodule Hackerrank.Infer.PPrint do
  alias Hackerrank.Infer.CharsProvider

  def pprint(type) do
    type
    |> format()
    |> String.replace_prefix("(", "")
    |> String.replace_suffix(")", "")
    |> add_forall()
  end

  def add_forall(type_str) do
    chars = CharsProvider.get_all_chars()

    "forall[" <> Enum.join(chars, " ") <> "] " <> type_str
  end
  def format({:fun, [l, r]}) do
    "(" <> format(l) <> " -> " <> format(r) <> ")"
  end

  def format(id) when is_integer(id) do
    CharsProvider.get_char(id)
  end
end

defmodule Hackerrank.Infer do
  alias Hackerrank.Infer.IdsProvider

  def list(a), do: {:list, [a]}
  def tup(args), do: {:tup, args}
  def fun(args), do: {:fun, args}

  def offset_type({type, args}) do
    {type, replace_args(args)}
  end

  def updater(k) do
    case k do
      nil ->
        id = IdsProvider.next_id()
        {id, id}

      k ->
        {k, k}
    end
  end

  def replace_args(args, acc \\ [], env \\ %{})

  def replace_args([arg | rest], acc, env) do
    {id, new_env} = Map.get_and_update(env, arg, &updater/1)
    replace_args(rest, [id | acc], new_env)
  end

  def replace_args([], acc, _env) do
    Enum.reverse(acc)
  end

  def env do
    %{
      id: fun([0, 0])
    }
  end

  def main() do
    # t_env = %{
    #   head: fun([list(0), 0]),
    #   tail: fun([list(0), list(0)]),
    #   nil: list(0),
    #   cons: fun([
    #     tup([0, list(0)]),
    #     list(0)
    #   ]),
    #   one: :int,
    #   zero: :int
    # }
  end

  def extract_equations(equations \\ %{}, expr, env)

  def extract_equations(equations, {:fun, args, expr} = call, env) do
    args_type_id = IdsProvider.next_id()
    expr_type_id = IdsProvider.next_id()

    equations
    |> extract_equations(expr, env)
    |> extract_equations(args, env)
    |> add_equation({args, args_type_id})
    |> add_equation({expr, expr_type_id})
    |> add_equation({call, fun([args_type_id, expr_type_id])})
  end

  def extract_equations(equations, {:call, l_exp, args} = call, env) do
    call_result_type_id = IdsProvider.next_id()
    from_args_type_id = IdsProvider.next_id()

    equations
    |> extract_equations(l_exp, env)
    |> extract_equations(args, env)
    |> add_equation({call, call_result_type_id})
    |> add_equation({args, from_args_type_id})
    |> add_equation({l_exp, fun([from_args_type_id, call_result_type_id])})
  end

  def extract_equations(equations, {:let, ident, expr, r_expr} = let, env) do
    ident_expr_type_id = IdsProvider.next_id()
    let_block_type_id = IdsProvider.next_id()

    equations
    |> extract_equations(ident, env)
    |> extract_equations(expr, env)
    |> extract_equations(r_expr, env)
    |> add_equation({ident, ident_expr_type_id})
    |> add_equation({expr, ident_expr_type_id})
    |> add_equation({r_expr, let_block_type_id})
    |> add_equation({let, let_block_type_id})
  end

  def extract_equations(equations, ident, env) do
    case Map.get(env, ident) do
      nil ->
        ident_type_id = IdsProvider.next_id()
        add_equation(equations, {ident, ident_type_id})

      type ->
        offseted_type = offset_type(type)
        add_equation(equations, {ident, offseted_type})
    end
  end

  def add_equation(equations, {id, t}) do
    Map.update(equations, id, [t], fn old -> [t | old] end)
  end

  def resolve(equations) do
    # {resolved, new_env} = resolve(equations, %{})
    resolve(equations, %{})
  end

  def resolve(equations, env) do
    {:ok, pid} = Agent.start(fn -> env end)

    unificator = fn {k, [type | types]} ->
      type = unify_types(type, types, pid)
      {k, type}
    end

    Map.new(equations, unificator)
  end

  def unify_types(type, [], env) do
    Agent.get(env, fn m -> Map.get(m, type, type) end)
  end

  def unify_types(type, [r_type | rest], env) do
    l_c_type = Agent.get(env, fn m -> Map.get(m, type, type) end)
    r_c_type = Agent.get(env, fn m -> Map.get(m, r_type, r_type) end)

    r_type = merge_types(l_c_type, r_c_type, env)

    IO.inspect(l_c_type, label: "l type")
    IO.inspect(r_c_type, label: "r type")
    IO.inspect(r_type, label: "result type")

    unify_types(r_type, rest, env)
  end

  def merge_types(l_type, r_type, env) when is_integer(l_type) and is_integer(r_type) do # type_var, type_var
    Agent.update(env, fn m -> Map.put(m, l_type, r_type) end)
    r_type
  end

  def merge_types(l_type, {:fun, [_f_type, _t_type]} = r_type, env) when is_integer(l_type) do
    Agent.update(env, fn m -> Map.put(m, l_type, r_type) end)
    r_type
  end

  def merge_types({:fun, _} = l_type, r_type, env) when is_integer(r_type) do
    Agent.update(env, fn m -> Map.put(m, r_type, l_type) end)
    l_type
  end
end
