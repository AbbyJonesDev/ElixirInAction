defmodule Todo.ProcessRegistry do
  # Forward requests to Registry
  def start_link() do
    Registry.start_link(keys: :unique, name: __MODULE__)
  end

  # Helper for consuming modules
  # Creates a valid via tuple to register a process with the registry
  def via_tuple(key) do
    {:via, Registry, {__MODULE__, key}}
  end

  # Registry should be supervised, so provide a child_spec for the
  # supervisor to use
  # Modifies the Registry child_spec by setting the `id` and `start` fields
  def child_spec(_) do
    Supervisor.child_spec(
      Registry,
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    )
  end
end
