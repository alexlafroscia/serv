defmodule FileServer.Registry do
  @moduledoc """
  Stores a map from file names to their bucket
  """
  use GenServer

  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, name: :file_server_registry)
  end

  @doc """
  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def lookup(file_name) do
    GenServer.call(:file_server_registry, {:lookup, file_name})
  end

  @doc """
  Ensures there is a bucket associated with the given `file_name` in `registry`.
  """
  def create(file_name) do
    GenServer.cast(:file_server_registry, {:create, file_name})
  end

  ## Server Callbacks

  def init(:ok) do
    files = %{}
    refs = %{}
    {:ok, {files, refs}}
  end

  def handle_call({:lookup, file_name}, _from, {files, _} = state) do
    {:reply, Map.fetch(files, file_name), state}
  end

  def handle_cast({:create, file_name}, {files, refs}) do
    if Map.has_key?(files, file_name) do
      {:noreply, {files, refs}}
    else
      {:ok, bucket} = FileServer.Bucket.start_link([])
      ref = Process.monitor(bucket)
      refs = Map.put(refs, ref, file_name)
      files = Map.put(files, file_name, bucket)
      {:noreply, {files, refs}}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, {files, refs}) do
    {file_name, refs} = Map.pop(refs, ref)
    files = Map.delete(files, file_name)
    {:noreply, {files, refs}}
  end

  def handle_info(_msg, state), do: {:noreply, state}
end
