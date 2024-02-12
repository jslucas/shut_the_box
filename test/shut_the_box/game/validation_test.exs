defmodule ShutTheBox.Game.ValidationTest do
  alias ShutTheBox.Game.Turn
  use ShutTheBox.DataCase

  alias ShutTheBox.Game.Validation

  test "gives valid sum combinations for target" do
    assert Validation.all_tile_combinations([1]) == [[1]]
    assert Validation.all_tile_combinations(%Turn{tiles: %{1 => false}}, [1]) == []

    assert Validation.all_tile_combinations(
             %Turn{tiles: %{1 => true, 2 => true, 3 => true, 4 => false, 6 => true}},
             [3, 3]
           ) == [[1, 2, 3], [6]]

    assert Validation.all_tile_combinations([4, 4]) ==
             [
               [1, 2, 5],
               [1, 3, 4],
               [1, 7],
               [2, 6],
               [3, 5],
               [8]
             ]
  end
end
