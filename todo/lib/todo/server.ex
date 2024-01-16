defmodule Todo.Server do
  use GenServer

  # Server functions used by GenServer

  @impl GenServer
  def init(list_name) do
    {:ok, {list_name, Todo.Database.get(list_name) || Todo.List.new()}}
  end

  @impl GenServer
  def handle_call({:entries, date}, _request_meta, {_list_name, list} = state) do
    # {:reply, Todo.Database.get(list_name), state}
    {:reply, Todo.List.entries(list, date), state}
  end

  @impl GenServer
  def handle_cast({:add_entry, new_entry}, {list_name, list} = _state) do
    new_list = Todo.List.add_entry(list, new_entry)
    Todo.Database.store(list_name, new_list)

    {:noreply, {list_name, new_list}}
  end

  # Interface functions used by the Todo.Server client

  def start(list_name) do
    GenServer.start(__MODULE__, list_name)
  end

  def add_entry(pid, new_entry) do
    GenServer.cast(pid, {:add_entry, new_entry})
  end

  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end
end
