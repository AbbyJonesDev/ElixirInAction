defmodule Todo.CacheTest do
  use ExUnit.Case

  test "server_process" do
    bob_pid = Todo.Cache.server_process("Bob")

    assert bob_pid != Todo.Cache.server_process("Alice")
    assert bob_pid == Todo.Cache.server_process("Bob")
  end

  test "to-do operations" do
    alice = Todo.Cache.server_process("alice")
    Todo.Server.add_entry(alice, %{date: ~D[2024-01-14], title: "dishes"})
    entries = Todo.Server.entries(alice, ~D[2024-01-14])

    assert [%{date: ~D[2024-01-14], title: "dishes"}] = entries
  end
end
