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
    assert Parser.tokenizeString(result) == {:ok, [["add", "1", "2"], ["add", "3", "4"]]}
  end

  test "verify the correct syntax tree" do
    assert Parser.constructSyntaxTree({:ok, [["add", "1", "2"], ["add", "3", "4"]]}) ==
             {:ok, [ok: {:add, "1", "2"}, ok: {:add, "3", "4"}]}
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
end
