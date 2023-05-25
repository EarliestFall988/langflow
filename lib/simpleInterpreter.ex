defmodule SimpleInterpreter do
  @moduledoc """
  Documentation for `SimpleInterpreter`.
  """

  def interpretTree({:ok, res}) do
    interpretTree(res)
  end

  def interpretTree(tree) do
    tree
    |> Enum.map(fn {_, {op, arg1, arg2}} -> completeOperationsRecursively(op, arg1, arg2) end)
  end

  @spec completeOperationsRecursively(:add | :div | :mul | :sub | :mod, number, number) :: number
  def completeOperationsRecursively(op, arg1, arg2) do
    arg1 =
      case arg1 do
        {:ok, {op2, arg5, arg6}} -> completeOperationsRecursively(op2, arg5, arg6)
        _ -> arg1
      end

    arg2 =
      case arg2 do
        {:ok, {op3, arg3, arg4}} ->
          completeOperationsRecursively(op3, arg3, arg4)

        _ ->
          arg2
      end

    completeOperation(op, arg1, arg2)
  end

  def completeOperation(op, arg1, arg2) do
    case op do
      :add -> arg1 + arg2
      :sub -> arg1 - arg2
      :mul -> arg1 * arg2
      :div -> arg1 / arg2
      :mod -> rem(arg1, arg2)
    end
  end
end
