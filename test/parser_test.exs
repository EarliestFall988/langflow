defmodule ParserTest do
  use ExUnit.Case
  doctest Parser

  def readFile(filename) do
    case File.read("sample scripts/#{filename}") do
      {:ok, file} ->
        file

      {:error, reason} ->
        IO.puts("ERR: #{reason}")
        exit("ERR: #{reason}")
    end
  end

  test "verify files exist" do
    assert File.exists?("sample scripts/addition.txt")
    assert File.exists?("sample scripts/script.txt")
  end

  test "tokenize string with comments" do
    result = readFile("addition.txt")

    assert Parser.tokenizeString(result) ==
             {:ok, [["add", "1", "2"], ["mul", "3", "4"], ["div", "25", "5"]]}
  end

  test "verify grouping correct" do
    assert Parser.nestGroups(["add", "1", "2"]) == ["add", "1", "2"]
  end

  test "verify grouping correct with nested operation" do
    assert Parser.nestGroups(["add", "1", "add", "4", "6"]) == ["add", "1", ["add", "4", "6"]]
  end

  test "verify grouping correct with nested operation 2" do
    assert Parser.nestGroups(["add", "1", "add", "4", "mul", "5", "3"]) == [
             "add",
             "1",
             ["add", "4", ["mul", "5", "3"]]
           ]
  end

  test "verify the correct syntax tree" do
    assert Parser.constructSyntaxTree({:ok, [["add", "1", "2"], ["add", "3", "4"]]}) ==
             {:ok, [ok: {:add, 1, 2}, ok: {:add, 3, 4}]}
  end

  test "tree construction returns error safely with no operator" do
    assert Parser.constructSyntaxTree({:ok, [["1", "2"], ["add", "3", "4"]]}) ==
             {:error, "invalid syntax"}
  end

  test "tree construction returns error safely with no value" do
    assert Parser.constructSyntaxTree({:ok, [["mult", "1"], ["add", "3", "4"]]}) ==
             {:error, "invalid syntax"}
  end

  test "tree construction returns error safely with no value 2" do
    assert Parser.constructSyntaxTree({:ok, [["mult", "1"], ["add", "4"]]}) ==
             {:error, "invalid syntax"}
  end

  test "tree construction returns error safely with no value 3" do
    assert Parser.constructSyntaxTree({:ok, [["mult", "1"], ["add"]]}) ==
             {:error, "invalid syntax"}
  end

  test "tree construction returns error safely with no value 4" do
    assert Parser.constructSyntaxTree({:ok, [["mult", "1"], ["add", ""]]}) ==
             {:error, "invalid syntax"}
  end

  test "tree construction returns error safely with invalid operator" do
    assert Parser.constructSyntaxTree({:ok, [["sha-sheeesh", "1", "2"], ["add", "3", "4"]]}) ==
             {:error, "invalid operation"}
  end

  test "tree construction returns error safely with invalid operator and no value" do
    assert Parser.constructSyntaxTree({:ok, [["sha-sheeesh", "1", "2"], ["add", "3"]]}) ==
             {:error, "invalid"}
  end

  test "testing complex tree" do
    code = {:ok, [["add", "1", "2"], ["div", "3", ["mul", "4", "5"]]]}

    assert Parser.constructSyntaxTree(code) ==
             {:ok, [ok: {:add, 1, 2}, ok: {:div, 3, [ok: {:mul, 4, 5}]}]}
  end


  test "parse"
end
