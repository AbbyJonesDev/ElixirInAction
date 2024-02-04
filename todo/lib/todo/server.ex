defmodule Todo.Server do
  use GenServer, restart: :temporary

  # Interface functions used by the Todo.Server client

  def start_link(list_name) do
    IO.puts("Starting Todo Server for #{list_name}")
    GenServer.start_link(__MODULE__, list_name, name: via_tuple(list_name))
  end

  def add_entry(pid, new_entry) do
    GenServer.cast(pid, {:add_entry, new_entry})
  end

  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end

  defp via_tuple(list_name) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, list_name})
  end

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
end
