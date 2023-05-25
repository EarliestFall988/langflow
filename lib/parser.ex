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

  def recursiveCreateTree([op, arg1, arg2]) do
    case checkOperator(op) do
      true ->
        {:ok, {String.to_atom(op), recursiveCreateTree(arg1), recursiveCreateTree(arg2)}}

      false ->
        {:error, "invalid operation"}
    end
  end

  def recursiveCreateTree(arg) do
    String.to_integer(arg)
  end

  def checkOperator(op) do
    case op do
      "add" -> true
      "sub" -> true
      "mul" -> true
      "div" -> true
      "mod" -> true
      _ -> false
    end
  end

  def nestGroups(data) do
    # IO.inspect(data)

    groupItems(Enum.reverse(data), [], [])
    |> Enum.at(0)

    # |> IO.inspect()
  end

  def groupItems(data, group, res) do
    case data do
      [] ->
        res

      [head | tail] ->
        if checkOperator(head) do
          newGroup = [head] ++ group

          groupItems(tail, [], [newGroup ++ res])
        else
          groupItems(tail, [head] ++ group, res)
        end
    end
  end

  def constructSyntaxTree({:ok, data}) do
    # try do

    res =
      data
      |> Enum.map(fn line ->
        case line do
          [op, arg1, arg2] ->
            recursiveCreateTree([op, arg1, arg2])

          _ ->
            {:error, "invalid syntax"}
        end
      end)

    {:ok, res}

    # invalidSyntax =
    #   Enum.filter(result, fn line ->
    #     line == {:error, "invalid syntax"}
    #   end)

    # invalidOperation =
    #   Enum.filter(result, fn line ->
    #     line == {:error, "invalid operation"}
    #   end)

    # case {invalidSyntax, invalidOperation} do
    #   {[], []} ->
    #     {:error, result}

    #   {[], _} ->
    #     {:error, "invalid operation"}

    #   {_, []} ->
    #     {:error, "invalid syntax"}

    #   {_, _} ->
    #     {:error, "invalid"}
    # end

    # rescue
    #   _ -> {:error, "error constructing syntax tree"}
    # end
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

  def parse(file) do
    case tokenizeString(file) do
      {:ok, data} ->
        res =
          Enum.map(data, fn x ->
            if Enum.count(x) > 3 do
              nestGroups(x)
            else
              x
            end
          end)

        constructSyntaxTree({:ok, res})

      {:error, reason} ->
        {:error, reason}
    end
  end
end
