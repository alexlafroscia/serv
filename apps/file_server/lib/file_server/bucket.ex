defmodule FileServer.Bucket do
  @moduledoc """
  A simple cache

  Used for:
  - Mapping tags to hashes, to avoid a DB lookup
  """
  use Agent

  @doc "Starts a new bucket"
  def start_link(_opts) do
    Agent.start_link fn -> %{} end
  end

  @doc "Fetch the value for a key from the bucket"
  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  @doc "Add a new key to the bucket"
  def put(bucket, key, value) do
    Agent.update(bucket, &Map.put(&1, key, value))
  end

  @doc "Remove a key from the bucket"
  def clear(bucket, key) do
    Agent.update bucket, fn(state) ->
      {_, updated_state} = Map.pop state, key
      updated_state
    end
  end
end
