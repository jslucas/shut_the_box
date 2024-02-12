defmodule ShutTheBox.Game.Validation do
  alias ShutTheBox.Game.Turn

  @doc """
  Returns uniqe combinations of uniqe values from nums where their sum equals the target

  ## Examples

      > Validation.all_tile_combinations(Turn.new(), 6)
      > [[1,2,3], [6]]
  """
  @spec all_tile_combinations(Turn.t(), list(Integer)) :: list(list(Integer))
  def all_tile_combinations(turn \\ Turn.new(), roll) when is_struct(turn, Turn) do
    target = Enum.sum(roll)
    open_tiles = Turn.open_tiles(turn)
    sum_combinations(open_tiles, target)
  end

  defp sum_combinations(nums, target) do
    dfs(nums, target, [], [])
    |> Enum.map(&Enum.sort/1)
  end

  # Base: target met with combination
  defp dfs(_, 0, current_combination, acc) do
    [current_combination | acc]
  end

  defp dfs([num | rest], target, current_combination, acc) when target > 0 do
    # Left: include the current number in the combination
    left = dfs(rest, target - num, [num | current_combination], acc)

    # Right: skip the current number and continue with the rest
    right = dfs(rest, target, current_combination, acc)

    left ++ right
  end

  # Base: target exceeded, stop recursing branch
  defp dfs(_, _, _, _), do: []
end
