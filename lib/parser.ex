defmodule Parser do
  def fail(reason) do
    IO.puts("Error: #{reason}")
    exit(reason)
  end

  def tokenizeString(data) do
    try do
      result =
        data
        |> String.split("\n")
        |> Enum.reject(fn line -> String.trim(line) == "" end)
        |> Enum.reject(fn line -> String.starts_with?(line, "//") end)
        |> Enum.map(fn line -> String.split(line, " ") end)
        |> Enum.map(fn line -> Enum.map(line, fn word -> String.trim(word) end) end)
        |> Enum.map(fn line -> Enum.reject(line, fn word -> word == "" end) end)

      {:ok, result}
    rescue
      _ -> {:error, "error parsing document"}
    end
  end

  def constructSyntaxTree({:ok, data}) do
    try do
      result =
        data
        |> Enum.map(fn line ->
          case line do
            [op, arg1, arg2] ->
              case op do
                "add" ->
                  {:ok, {:add, arg1, arg2}}

                "sub" ->
                  {:ok, {:sub, arg1, arg2}}

                "mul" ->
                  {:ok, {:mul, arg1, arg2}}

                "div" ->
                  {:ok, {:div, arg1, arg2}}

                _ ->
                  {:error, "invalid operation"}
              end

            _ ->
              {:error, "invalid syntax"}
          end
        end)

      invalidSyntax =
        Enum.filter(result, fn line ->
          line == {:error, "invalid syntax"}
        end)

      invalidOperation =
        Enum.filter(result, fn line ->
          line == {:error, "invalid operation"}
        end)

      case {invalidSyntax, invalidOperation} do
        {[], []} ->
          {:ok, result}

        {[], _} ->
          {:error, "invalid operation"}

        {_, []} ->
          {:error, "invalid syntax"}

        {_, _} ->
          {:error, "invalid"}
      end
    rescue
      _ -> {:error, "error constructing syntax tree"}
    end
  end

  def findInvalid(data, location, res) do
    case data do
      [] ->
        res

      [head | tail] ->
        case head do
          {:error, _reason} ->
            findInvalid(tail, location + 1, res ++ [location])

          _ ->
            findInvalid(tail, location + 1, res)
        end
    end
  end

  @spec parse(String.t()) :: {:ok, list} | {:error, String.t()}
  def parse(file) do
    case tokenizeString(file) do
      {:ok, data} ->
        constructSyntaxTree({:ok, data})

      {:error, reason} ->
        {:error, reason}
    end
  end
end
