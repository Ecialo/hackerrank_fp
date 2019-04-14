defmodule Hackerrank.DicePath.Field do
  use GenServer

  @default_start %{
    {1, 1} => {
      1,
      %{{1, 3, 4, 5, 2, 6} => 1}
    }
  }

  @type direction :: :left | :right | :up | :down
  @type cube :: {integer, integer, integer, integer, integer, integer}
  @type cubes :: %{required(cube) => integer}
  @type field :: %{required({integer, integer}) => {integer, cubes}}

  @spec default_start() :: %{
          optional({1, 1}) => {1, %{optional({any(), any(), any(), any(), any(), any()}) => 1}}
        }
  def default_start do
    @default_start
  end

  def find_max_path(pos) do
    GenServer.call(__MODULE__, {:get, pos})
  end

  def start_link(field_size) do
    GenServer.start_link(__MODULE__, field_size, name: __MODULE__)
  end

  def stop do
    GenServer.stop(__MODULE__)
  end

  def init(field_size) do
    {
      :ok,
      field_size,
      {:continue, :fill}
    }
  end

  def handle_continue(:fill, field_size) do
    field = fill(@default_start, {2, 1}, field_size)
    {:noreply, field}
  end

  def handle_call({:get, {y, x}}, _from, state) do
    {:reply, elem(state[{x, y}], 0), state}
  end

  @spec rotate(direction(), cube()) :: cube()
  def rotate(
    direction,
    {top, left, right, up, down, opposite}
  ) do
    case direction do
      :right -> {left, opposite, top, up, down, right}
      :left -> {right, top, opposite, up, down, left}
      :down -> {up, left, right, opposite, top, down}
      :up -> {down, left, right, top, opposite, up}
    end
  end

  @spec asume_came_from(direction(), {integer(), integer()}, cubes()) :: {integer(), cubes()}
  def asume_came_from(:left, {1, _}, _), do: {0, %{}}
  def asume_came_from(:up, {_, 1}, _), do: {0, %{}}
  def asume_came_from(direction, {dst_x, dst_y}, state) do
    {dx, dy, r_direction} = case direction do
      :left -> {-1, 0, :right}
      :up -> {0, -1, :down}
    end
    {_max_points, cube2points} = state[{dst_x + dx, dst_y + dy}]
    for {cube, points} <- cube2points, reduce: {0, %{}} do
      {m_points, new_cube2points} ->
        r_cube = rotate(r_direction, cube)
        new_points = points + elem(r_cube, 0)
        {max(m_points, new_points), Map.put(new_cube2points, r_cube, new_points)}
    end
  end

  @spec join_cubes(cubes, cubes) :: cubes
  def join_cubes(cubes_a, cubes_b) do
    for {cube, points} <- Enum.concat([cubes_a, cubes_b]), reduce: %{} do
      acc -> Map.put(acc, cube, max(Map.get(acc, cube, 0), points))
    end
  end

  @spec fill(field, {integer, integer}, {integer, integer}) :: field
  def fill(state, {x, y}, size = {m, _n}) when x > m, do: fill(state, {1, y + 1}, size)
  def fill(state, {_, y}, _size = {_m, n}) when y > n, do: state
  def fill(state, pos = {x, y}, size) do
    {p_left, c_left} = asume_came_from(:left, pos, state)
    {p_up, c_up} = asume_came_from(:up, pos, state)
    new_state = Map.put(
      state, pos,
      {
        max(p_left, p_up),
        join_cubes(c_left, c_up)
      }
    )
    fill(new_state, {x + 1, y}, size)
  end
end

defmodule Hackerrank.DicePath do

  alias Hackerrank.DicePath.Field

  def main do
    Field.start_link({60, 60})
    IO.read(:line)
    IO.read(:all)
      |> String.trim
      |> String.split("\n")
      |> Enum.map(
        fn line -> line
                  |> String.split
                  |> Enum.map(&String.to_integer/1)
                  |> List.to_tuple
                  |> Field.find_max_path
        end)
      |> Enum.join("\n")
      |> IO.write
  end

end
