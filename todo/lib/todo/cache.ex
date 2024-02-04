defmodule Todo.Cache do
  use GenServer

  def start_link(_) do
    IO.puts("Starting Todo Cache")
    # Use registered name because it will be started by Supervisor
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def server_process(todo_list_name) do
    # Now that process is registered using start_link -
    # it can be called using its registered name without knowing its pid
    GenServer.call(__MODULE__, {:server_process, todo_list_name})
  end

  @impl GenServer
  def init(_) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:server_process, todo_list_name}, _from, todo_servers) do
    case Map.fetch(todo_servers, todo_list_name) do
      {:ok, todo_server} ->
        {:reply, todo_server, todo_servers}

      :error ->
        {:ok, new_server} = Todo.Server.start_link(todo_list_name)

        {
          :reply,
          new_server,
          Map.put(todo_servers, todo_list_name, new_server)
        }
    end
  end
end
