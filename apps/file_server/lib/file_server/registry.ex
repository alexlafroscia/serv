defmodule FileServer.Registry do
  @moduledoc """
  Stores a map from file names to their bucket
  """
  require Logger
  use GenServer

  alias FileServer.Bucket

  @name :file_server_registry
  @initial_state {%{}, %{}}

  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, Keyword.merge(
      opts, name: @name
    ))
  end

  @doc """
  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def lookup(file_name), do: GenServer.call(@name, {:lookup, file_name})

  @doc """
  Ensures there is a bucket associated with the given `file_name` in `registry`.
  """
  def create(file_name), do: GenServer.call(@name, {:create, file_name})

  @doc """
  Clear the state of the registry
  """
  def purge(), do: GenServer.call(@name, {:purge})

  ## Server Callbacks

  def init(:ok), do: {:ok, @initial_state}

  def handle_call({:lookup, file_name}, _from, {files, _} = state) do
    {:reply, Map.fetch(files, file_name), state}
  end

  def handle_call({:create, file_name}, _from, {files, refs}) do
    if Map.has_key?(files, file_name) do
      {:reply, Map.fetch(files, file_name), {files, refs}}
    else
      {:ok, bucket} = Bucket.start_link([])
      ref = Process.monitor(bucket)
      refs = Map.put(refs, ref, file_name)
      files = Map.put(files, file_name, bucket)

      {:reply, {:ok, bucket}, {files, refs}}
    end
  end

  def handle_call({:purge}, _from, _old_state) do
    {:reply, :ok, @initial_state}
  end

  def handle_cast({:update, file_name, label, value}, {files, _} = state) do
    with {:ok, bucket} <- Map.fetch(files, file_name),
         :ok <- Bucket.put(bucket, label, value)
    do
      Logger.info "Updated #{file_name} tag #{label} to #{value}"
      {:noreply, state}
    else
      :error ->
        {:noreply, state}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, {files, refs}) do
    {file_name, refs} = Map.pop(refs, ref)
    files = Map.delete(files, file_name)
    {:noreply, {files, refs}}
  end

  def handle_info(_msg, state), do: {:noreply, state}
end
