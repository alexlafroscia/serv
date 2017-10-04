defmodule FileServer.RegistryTest do
  use ExUnit.Case

  alias FileServer.Registry
  alias FileServer.Bucket

  setup do
    # Reset the registry between each test
    on_exit fn ->
      ref = Process.monitor(:file_server_registry)
      GenServer.stop :file_server_registry
      assert_receive {:DOWN, ^ref, _, _, _}
    end

    :ok
  end

  test "it returns :error for an unknown file" do
    assert Registry.lookup("foo.txt") == :error
  end

  test "it returns the PID for a bucket when one exists" do
    assert Registry.create("foo.txt") == :ok

    {:ok, bucket} = Registry.lookup("foo.txt")
    assert Bucket.get(bucket, "default") == nil

    Bucket.put(bucket, "default", "foobar")
    assert Bucket.get(bucket, "default") == "foobar"
  end

  test "it removes buckets when they crash" do
    Registry.create("shopping")
    {:ok, bucket} = Registry.lookup("shopping")

    Agent.stop(bucket)

    assert Registry.lookup("shopping") == :error
  end
end
