defmodule FileServer.RegistryTest do
  use ExUnit.Case

  alias FileServer.Registry
  alias FileServer.Bucket

  setup do
    # Reset the registry between each test
    on_exit fn ->
      Registry.purge()
    end

    :ok
  end

  describe ".create" do
    test "it returns a bucket PID when created" do
      assert {:ok, bucket} = Registry.create("foo.txt")

      Bucket.put(bucket, "default", "foo")
      assert Bucket.get(bucket, "default") == "foo"
    end

    test "it does not error when creating a file again" do
      {:ok, bucket_first} = Registry.create("foo.txt")
      {:ok, bucket_second} = Registry.create("foo.txt")

      assert bucket_first == bucket_second
    end
  end

  describe ".lookup" do
    test "it returns :error for an unknown file" do
      assert Registry.lookup("foo.txt") == :error
    end

    test "it returns the PID for a bucket when one exists" do
      {:ok, bucket_create_pid} = Registry.create("foo.txt")

      {:ok, bucket} = Registry.lookup("foo.txt")
      assert bucket == bucket_create_pid

      assert Bucket.get(bucket, "default") == nil

      Bucket.put(bucket, "default", "foobar")
      assert Bucket.get(bucket, "default") == "foobar"
    end
  end

  describe ".purge" do
    test "clears a stored bucket" do
      {:ok, _} = Registry.create("foo.txt")
      :ok = Registry.purge()

      assert Registry.lookup("foo.txt") == :error
    end

    @tag :skip
    test "it kills the bucket processes"
  end

  test "it removes buckets when they crash" do
    Registry.create("shopping")
    {:ok, bucket} = Registry.lookup("shopping")

    Agent.stop(bucket)

    assert Registry.lookup("shopping") == :error
  end
end
