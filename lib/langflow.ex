defmodule Langflow do
  alias Parser, as: Parser
  alias SimpleInterpreter, as: SimpleInterpreter

  @moduledoc """
  Documentation for `Langflow`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Langflow.hello()
      :world

  """
  def hello do
    :world
  end

  def start(_type, _args) do
    Task.start(fn -> runProgram("addition.txt") end)
  end

  def runProgram(file) do
    IO.puts("Running #{file}...")
    IO.puts("\n\n\---------Results----------\n\n")

    case openFile(file) do
      {:ok, result} ->
        Parser.parse(result)
        |> SimpleInterpreter.interpretTree()
        |> IO.inspect()

        :ok

      {:error, reason} ->
        IO.puts("ERR: #{reason}")
        # IO.inspect(reason)

        :error
    end
  end

  def openFile(filename) do
    case File.read("sample scripts/#{filename}") do
      {:ok, file} ->
        # case Parser.parse(file) do
        #   {:ok, result} ->
        #     {:ok, result}
        # end
        # IO.inspect(file)
        {:ok, file}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
