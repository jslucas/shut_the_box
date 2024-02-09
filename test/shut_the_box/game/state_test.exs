defmodule ShutTheBox.Game.StateTest do
  use ExUnit.Case, async: true

  alias ShutTheBox.Game.Player
  alias ShutTheBox.Game.State

  describe ".add_player/2" do
    test "adds player to game" do
      game = State.new("NICE-GAME")

      assert game = State.add_player(game, Player.new("1"))
      assert [%Player{name: "1"}] = game.players
      assert game = State.add_player(game, Player.new("2"))
      assert [%Player{name: "2"}, %Player{name: "1"}] = game.players
    end
  end

  describe ".start_game/1" do
    test "sets turn order and updates turn" do
      game = State.new("NICE-GAME")
      player = Player.new("1")
      player_id = player.id

      assert game = State.add_player(game, player)
      assert %{turn_order: nil, turn: %{step: :waiting_to_start, player_id: nil}} = game
      assert game = State.start_game(game)

      assert %{
               turn_order: [^player_id],
               turn: %{step: :roll, player_id: ^player_id}
             } = game
    end
  end

  describe ".roll/1" do
    test "sets roll and updates turn step to close tiles" do
      assert %{roll: [die1, die2], turn: %{step: :close_tiles}} =
               State.roll(%State{turn: %{step: :roll}})

      assert Enum.member?(1..6, die1)
      assert Enum.member?(1..6, die2)
    end
  end

  describe ".close_tiles/2" do
    test "updates the input tiles to false and sets turn step to roll" do
      {:ok, %{turn: %{tiles: tiles, step: :roll}}} =
        State.new(%{roll: [3, 3]}) |> State.close_tiles([1, 2, 3])

      assert %{
               1 => false,
               2 => false,
               3 => false,
               4 => true,
               5 => true,
               6 => true,
               7 => true,
               8 => true,
               9 => true
             } = tiles
    end

    test "returns error if trying to close tiles that are not open" do
      {:error, "Invalid tile selection"} =
        State.new(%{roll: [1], turn: %{step: :close_tiles, tiles: %{1 => false}}})
        |> State.close_tiles([1])
    end

    test "returns error if the sum of tiles being closed does not match the sum of roll" do
      {:error, "Invalid tile selection"} =
        State.new(%{roll: [1], turn: %{step: :close_tiles, tiles: %{1 => true, 2 => true}}})
        |> State.close_tiles([2])
    end
  end
end
