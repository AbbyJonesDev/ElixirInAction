defmodule Todo.CacheTest do
  use ExUnit.Case

  test "server_process" do
    {:ok, cache} = Todo.Cache.start()
    bob_pid = Todo.Cache.server_process(cache, "Bob")

    assert bob_pid != Todo.Cache.server_process(cache, "Alice")
    assert bob_pid == Todo.Cache.server_process(cache, "Bob")
  end

  test "to-do operations" do
    {:ok, cache} = Todo.Cache.start()

    alice = Todo.Cache.server_process(cache, "alice")
    Todo.Server.add_entry(alice, %{date: ~D[2024-01-14], title: "dishes"})
    entries = Todo.Server.entries(alice, ~D[2024-01-14])

    assert [%{date: ~D[2024-01-14], title: "dishes"}] = entries
  end
end
