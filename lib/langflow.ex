defmodule Langflow do
  alias Parser, as: Parser

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
    IO.puts("starting")
    # some more stuff
    Task.start(fn -> IO.puts("\n\n---------Result----------\n" <> openFile("addition.txt")) end)
  end

  def openFile(filename) do
    case File.read("sample scripts/#{filename}") do
      {:ok, file} ->
        case Parser.parse(file) do
          {:ok, result} ->
            IO.inspect(result)
            "OK"

          {:error, reason} ->
            IO.inspect(reason)
            exit(reason)
        end

      {:error, reason} ->
        # IO.puts("ERR: #{reason}")
        IO.inspect(reason)
        exit(reason)
    end
  end
end
