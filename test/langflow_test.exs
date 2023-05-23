defmodule LangflowTest do
  use ExUnit.Case
  doctest Langflow

  test "greets the world" do
    assert Langflow.hello() == :world
  end
end
