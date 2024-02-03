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
end
