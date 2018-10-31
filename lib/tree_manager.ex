defmodule Hackerrank.Tree.Node do
  alias __MODULE__

  defstruct [
    right: nil,
    child: nil,
    value: 0
  ]

  @type t :: %Node{right: Node.t | nil, child: Node.t | nil, value: integer}

end

defmodule Hackerrank.Tree.Zipper do

  alias Hackerrank.Tree.{Node, Zipper}

  defstruct [
    scope: %Node{},
    path: []
  ]

  @type direction :: :left | :right | :parent | :child
  @type t :: %Zipper{scope: Node.t, path: [{direction, Node.t}]}

  def new do
    %Zipper{}
  end

  @spec invert(direction) :: direction
  def invert(direction) do
    case direction do
      :left -> :right
      :right -> :left
      :parent -> :child
      :child -> :parent
    end
  end

  def print(zipper = %Zipper{scope: scope}) do
    IO.write("#{scope.value}\n")
    zipper
  end

  def update_parent(
    zipper = %Zipper{scope: scope, path: [{from_direction, parent} | tail]}
  ) do
    new_parent = case from_direction do
      :left -> %Node{parent | right: scope}
      :parent -> %Node{parent | child: scope}
    end
    %Zipper{zipper | path: [{from_direction, new_parent} | tail]}
  end

  def rollback(
    zipper = %Zipper{path: [{_, parent} | tail]}
  ) do
    %Zipper{zipper | scope: parent, path: tail}
  end

  def visit(zipper, direction) do
    visit(zipper, direction, 1)
  end

  def visit(zipper, _, 0) do
    zipper
  end

  def visit(
    zipper = %Zipper{scope: scope, path: path},
    direction,
    times
  ) when direction in [:right, :child] do
    case Map.fetch(scope, direction) do
      {:ok, nil} -> :error
      {:ok, new_scope} ->
        new_path = [{invert(direction), scope} | path]
        new_zipper = %Zipper{zipper | scope: new_scope, path: new_path}
        visit(new_zipper, direction, times - 1)
    end
  end

  def visit(
    %Zipper{path: []},
    direction,
    _
  ) when direction in [:left, :parent] do
    :error
  end

  def visit(
    zipper = %Zipper{path: [{from_direction, _prev_node} | _]},
    direction,
    times
  ) when direction in [:left, :parent] do
    case {direction, from_direction} do
      {:left, :parent} ->
        :error
      {:parent, :left} ->
        zipper
          |> update_parent()
          |> rollback()
          |> visit(direction, times)
      _ ->
        zipper
          |> update_parent()
          |> rollback()
          |> visit(direction, times - 1)
    end
  end

  def change_value(zipper = %Zipper{scope: scope}, x) do
    %Zipper{zipper | scope: %Node{scope | value: x}}
  end

  def insert(
    zipper = %Zipper{scope: scope},
    direction,
    x
  ) when direction in [:child, :right] do
    case Map.fetch(scope, direction) do
      {:ok, nil} ->
        %Zipper{zipper | scope: %{
          scope | direction => %Node{value: x}
        }}
      {:ok, node} ->
        %Zipper{zipper | scope: %{
          scope | direction => %Node{value: x, right: node}
        }}
    end
  end

  def insert(
    zipper = %Zipper{
      scope: scope,
      path: []
    },
    :left,
    x
  ) do
    %Zipper{zipper | path: [{
      :right,
      %Node{
        value: x,
        right: scope
      }
    }]}
  end

  @spec insert(t, direction, integer) :: t
  def insert(
    zipper = %Zipper{
      scope: scope,
      path: [{from_direction, parent} | tail]
    },
    :left,
    x
  ) do
    new_node = %Node{right: scope, value: x}
    new_parent = case from_direction do
      :parent -> %Node{parent | child: new_node}
      :left -> %Node{parent | right: new_node}
    end
    new_path = [{:left, new_node} | [{from_direction, new_parent} | tail]]
    %Zipper{zipper | path: new_path}
  end

  def delete(
    zipper = %Zipper{scope: scope, path: [{from_direction, parent} | tail]}
  ) do
    new_parent = case from_direction do
      :left -> %Node{parent | right: scope.right}
      :parent -> %Node{parent | child: scope.right}
    end
    new_path = [{from_direction, new_parent} | tail]
    new_zipper = %Zipper{zipper | scope: scope.right, path: new_path}
    visit(new_zipper, :parent)
  end

end

defmodule Hackerrank.TreeManager do
  alias Hackerrank.Tree.Zipper

  def main do
    IO.read(:line)
    IO.read(:all)
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split/1)
      |> execute_many()
  end

  def execute_many(commands) when is_list(commands) do
    execute_many(Zipper.new(), commands)
  end

  def execute_many(zipper, []) do
    zipper
  end

  def execute_many(zipper, [command | tail]) do
    zipper |> execute(command) |> execute_many(tail)
  end

  def execute(zipper, ["change", x]) when is_binary(x) do
    Zipper.change_value(zipper, String.to_integer(x))
  end

  def execute(zipper, ["print"]) do
    Zipper.print(zipper)
  end

  def execute(zipper, ["visit", "child", n]) do
    zipper
      |> Zipper.visit(:child)
      |> Zipper.visit(:right, String.to_integer(n) - 1)
  end

  def execute(zipper, ["visit", direction]) when is_binary(direction) do
    Zipper.visit(zipper, String.to_atom(direction))
  end

  def execute(zipper, ["insert", direction, x]) when is_binary(direction) do
    Zipper.insert(zipper, String.to_atom(direction), String.to_integer(x))
  end

  def execute(zipper, ["delete"]) do
    Zipper.delete(zipper)
  end

end
