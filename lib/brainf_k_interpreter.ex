defmodule Hackerrank.BrainFuck.Memory do
  alias __MODULE__

  defstruct [left: [], scope: 0, right: []]

  def new() do
    %Memory{}
  end

  def move(
    %Memory{left: left, scope: scope, right: []},
    :right
  ) do
    %Memory{left: [scope | left]}
  end

  def move(
    %Memory{left: left, scope: scope, right: [r_h | r_t]},
    :right
  ) do
    %Memory{left: [scope | left], scope: r_h, right: r_t}
  end

  def move(
    %Memory{left: []},
    :left
  ) do
    :error
  end

  def move(
    %Memory{left: [l_h | l_t], scope: scope, right: right},
    :left
  ) do
    %Memory{left: l_t, scope: l_h, right: [scope | right]}
  end

  def write(
    memory = %Memory{},
    value
  ) when is_integer(value) and 0 <= value and value < 256 do
    %Memory{memory | scope: value}
  end

  def read(%Memory{scope: scope}) do
    scope
  end

end

defmodule Hackerrank.BrainFuck.Command do

  alias __MODULE__

  defstruct [command: nil, complexity: 1]

  def new(command) do
    %Command{command: command}
  end

  def new(command, complexity) do
    %Command{command: command, complexity: complexity}
  end
end

defmodule Hackerrank.BrainFuck.Interpreter do
  alias Hackerrank.BrainFuck.{Memory, Command}

  @max_operations 100_000

  def main do
    IO.read(:line)
    [inpt, program] = IO.read(:all) |> String.split("$")
    program
      |> parse()
      |> Enum.reduce_while({Memory.new(), inpt, 0}, &evaluate/2)
      |> (fn {_, _, operations} ->
            if operations > @max_operations do
              IO.write("\nPROCESS TIME OUT. KILLED!!!\n")
            end
          end).()
  end

  def parse(program) do
    parse(program, [])
  end

  def parse("", acc) do
    Enum.reverse(acc)
  end

  def parse(
    <<h::binary-size(1), t::binary>>,
    acc
  ) when h in ~w"< > . ," do
    parse(t, [Command.new(h) | acc])
  end

  def parse(
    <<h::binary-size(1), t::binary>>,
    [%Command{command: {:change, val}, complexity: c} | acc_t]
  ) when h in ~w"+ -" do
    d = case h do
      "+" -> 1
      "-" -> -1
    end
    new_change = Command.new({:change, val + d}, c + 1)
    parse(t, [new_change | acc_t])
  end

  def parse(
    <<h::binary-size(1), t::binary>>,
    acc
  ) when h in ~w"+ -" do
    d = case h do
      "+" -> 1
      "-" -> -1
    end
    new_change = Command.new({:change, d})
    parse(t, [new_change | acc])
  end

  def parse(
    <<"[", t::binary>>,
    acc
  ) do
    {new_t, cycle_commands} = parse(t, [])
    new_cycle = Command.new({:cycle, cycle_commands})
    parse(new_t, [new_cycle | acc])
  end

  def parse(
    <<"]", t::binary>>,
    acc
  ) do
    {t, Enum.reverse(acc)}
  end

  def parse(<<_::binary-size(1), t::binary>>, acc) do
    parse(t, acc)
  end

  def mod(a, b) do
    rem(rem(a, b) + b, b)
  end

  def evaluate(
    _,
    {m, i, operations}
  ) when operations >= @max_operations do
    {:halt, {m, i, operations + 1}}
  end

  def evaluate(
    %Command{command: ">"},
    {memory, inpt, operations}
  ) do
    # IO.inspect("> +1 Total:#{operations + 1}")
    {:cont, {Memory.move(memory, :right), inpt, operations + 1}}
  end

  def evaluate(
    %Command{command: "<"},
    {memory, inpt, operations}
  ) do
    # IO.inspect("< +1 Total:#{operations + 1}")
    {:cont, {Memory.move(memory, :left), inpt, operations + 1}}
  end

  def evaluate(
    %Command{command: {:change, val}, complexity: c},
    {memory, inpt, operations}
  ) do
    # IO.inspect("change +#{c} Total:#{operations + c}")
    val = mod(Memory.read(memory) + val, 256)
    {:cont, {Memory.write(memory, val), inpt, operations + c}}
  end

  def evaluate(
    %Command{command: ","},
    {memory, <<h, inpt::binary>>, operations}
  ) do
    # IO.inspect(", +1 Total:#{operations + 1}")
    {:cont, {Memory.write(memory, h), inpt, operations + 1}}
  end

  def evaluate(
    %Command{command: "."},
    {memory, inpt, operations}
  ) do
    # IO.inspect(". +1 Total:#{operations + 1}")
    val = Memory.read(memory)
    IO.write(<<val>>)
    {:cont, {memory, inpt, operations + 1}}
  end

  def evaluate(
    c = %Command{command: {:cycle, _}},
    acc
  ) do
    evaluate(c, acc, :entry)
  end

  def evaluate(
    _,
    {m, i, operations},
    _
  ) when operations >= @max_operations do
    {:halt, {m, i, operations + 1}}
  end

  def evaluate(
    c = %Command{command: {:cycle, commands}},
    {memory, inpt, operations},
    :entry
  ) do
    val = Memory.read(memory)
    case val do
      0 ->
        # IO.inspect("cycle entry skip +2 Total:#{operations + 2}")
        {:cont, {memory, inpt, operations + 2}}
      _ ->
        # IO.inspect("cycle entry progress +1 Total:#{operations + 1}")
        new_acc = {memory, inpt, operations + 1}
        {memory, inpt, operations} =
          Enum.reduce_while(commands, new_acc, &evaluate/2)
        evaluate(c, {memory, inpt, operations}, :repeat)
    end
  end

  def evaluate(
    c = %Command{command: {:cycle, commands}},
    {memory, inpt, operations},
    :repeat
  ) do
    val = Memory.read(memory)
    case val do
      0 ->
        # IO.inspect("cycle exit progress +1 Total:#{operations + 1}")
        {:cont, {memory, inpt, operations + 1}}
      _ ->
        # IO.inspect("cycle entry rerun +2 Total:#{operations + 2}")
        new_acc = {memory, inpt, operations + 2}
        {memory, inpt, operations} =
          Enum.reduce_while(commands, new_acc, &evaluate/2)
        evaluate(c, {memory, inpt, operations}, :repeat)
    end
  end

end
