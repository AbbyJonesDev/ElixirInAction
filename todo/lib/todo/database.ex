defmodule Todo.Database do
  use GenServer

  @db_folder "./persist"

  def start() do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def store(key, data) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.store(key, data)
  end

  def get(key) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.get(key)
  end

  # Workers details are stored in the Database server process
  # Choosing the worker requires a synchronous call to the
  # Database server process to get a worker's pid
  # After this - we can delegate the rest of the work to
  # the worker process, and take advantage of greater concurrency
  # by having 3 workers
  defp choose_worker(key) do
    GenServer.call(__MODULE__, {:choose_worker, key})
  end

  @impl GenServer
  def init(_) do
    File.mkdir_p!(@db_folder)
    {:ok, start_workers()}
  end

  @impl GenServer
  def handle_call({:choose_worker, key}, _from, workers) do
    worker_key = :erlang.phash2(key, 3)
    IO.puts "Worker Key: #{inspect worker_key}"
    {:reply, Map.get(workers, worker_key), workers}
  end

  # Create 3 workers and return them in a map
  # where the keys are 0, 1, and 2
  # and the values are the pids of the workers
  defp start_workers() do
    for index <- 1..3, into: %{} do
      {:ok, pid} = Todo.DatabaseWorker.start(@db_folder)
      {index - 1, pid}
    end
  end
end
