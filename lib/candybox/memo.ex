defmodule Hackerrank.Candybox.Memo do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def retrieve(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def update(key, value) do
    GenServer.cast(__MODULE__, {:put, key, value})
  end

  def handle_call({:get, key}, _, state) do
    {:reply, Map.get(state, key), state}
  end

  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

end
