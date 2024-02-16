# Todo

Todo application as built by working through Elixir in Action, 2nd Edition.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `todo` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:todo, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/todo>.

## Testing in iex

```bash
iex -S mix
```

```elixir

# Create a list
bob = Todo.Cache.server_process("bob's list")

# Add an entry
Todo.Server.add_entry(bob, %{date: ~D[2024-01-15], title: "Elixir in Action Ch 7"})

# Retrieve entries
Todo.Server.entries(bob, ~D[2024-01-15])
```