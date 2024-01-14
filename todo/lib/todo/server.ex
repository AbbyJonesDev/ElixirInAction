defmodule Todo.Server do
  use GenServer

  # Server functions used by GenServer

  @impl GenServer
  def init(_) do
    {:ok, Todo.List.new()}
  end

  @impl GenServer
  def handle_call({:entries, date}, _request_meta, state) do
    {:reply, Todo.List.entries(state, date), state}
  end

  @impl GenServer
  def handle_cast({:add_entry, new_entry}, state) do
    {:noreply, Todo.List.add_entry(state, new_entry)}
  end

  # Interface functions used by the Todo.Server client

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def add_entry(pid, new_entry) do
    GenServer.cast(pid, {:add_entry, new_entry})
  end

  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end
end
