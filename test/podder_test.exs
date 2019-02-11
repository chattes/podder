defmodule PodderTest do
  use ExUnit.Case
  doctest Podder

  test "greets the world" do
    assert Podder.hello() == :world
  end
end
