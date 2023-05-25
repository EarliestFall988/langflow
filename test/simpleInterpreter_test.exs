defmodule SimpleInterpreterTest do
  use ExUnit.Case
  doctest SimpleInterpreter

  test "run addition" do
    assert SimpleInterpreter.completeOperation(:add, 1, 2) == 3
  end

  test "run subtraction" do
    assert SimpleInterpreter.completeOperation(:sub, 1, 2) == -1
  end

  test "run multiplication" do
    assert SimpleInterpreter.completeOperation(:mul, 1, 2) == 2
  end

  test "run division" do
    assert SimpleInterpreter.completeOperation(:div, 1, 2) == 0.5
  end

  test "run modulo" do
    assert SimpleInterpreter.completeOperation(:mod, 1, 2) == 1
  end

  test "interprets a simple addition" do
    assert SimpleInterpreter.interpretTree(ok: {:add, 1, 2}) == [3]
  end

  test "interprets a complex addition with list return" do
    assert SimpleInterpreter.interpretTree(ok: {:add, 1, 2}, ok: {:add, 3, 4}) == [3, 7]
  end

  test "interprets a complex addition with one return" do
    assert SimpleInterpreter.interpretTree(ok: {:add, 1, ok: {:add, 3, 4}}) == [8]
  end
end
