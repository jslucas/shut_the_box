defmodule ShutTheBox.Game.StateTest do
  use ExUnit.Case, async: true

  alias ShutTheBox.Game.Player
  alias ShutTheBox.Game.State

  describe ".add_player/2" do
    test "adds player to game" do
      game = State.new("NICE-GAME")

      assert {:ok, game} = State.add_player(game, Player.new("1"))
      assert [%Player{name: "1"}] = game.players
      assert {:ok, game} = State.add_player(game, Player.new("2"))
      assert [%Player{name: "2"}, %Player{name: "1"}] = game.players
    end
  end

  describe ".start_game/1" do
    test "sets turn order and updates turn" do
      game = State.new("NICE-GAME")
      player = Player.new("1")
      player_id = player.id

      assert {:ok, game} = State.add_player(game, player)
      assert %{turn_order: nil, turn: %{step: :waiting_to_start, player_id: nil}} = game
      assert {:ok, game} = State.start_game(game)

      assert %{
               turn_order: [^player_id],
               turn: %{step: :roll, player_id: ^player_id}
             } = game
    end
  end

  describe ".roll/1" do
    test "sets roll" do
      assert {:ok, %{roll: [die1, die2]}} = State.roll(%State{})
      assert Enum.member?(1..6, die1)
      assert Enum.member?(1..6, die2)
    end
  end
end
