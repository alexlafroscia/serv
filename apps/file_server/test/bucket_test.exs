defmodule FileServer.BucketTest do
  use ExUnit.Case, async: true

  alias FileServer.Bucket

  setup do
    {:ok, bucket} = start_supervised Bucket
    %{bucket: bucket}
  end

  test "stores a hash by tag", %{bucket: bucket} do
    assert Bucket.get(bucket, "default") == nil

    Bucket.put(bucket, "default", "some-long-hash")
    assert Bucket.get(bucket, "default") == "some-long-hash"
  end

  test "can clear a key", %{bucket: bucket} do
    Bucket.put(bucket, "default", "some-key")

    Bucket.clear(bucket, "default")
    assert Bucket.get(bucket, "default") == nil
  end
end

