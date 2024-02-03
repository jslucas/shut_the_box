defmodule ShutTheBox.Game.ServerTest do
  use ExUnit.Case, async: true

  alias ShutTheBox.Game.Player
  alias ShutTheBox.Game.{Server, Utils}

  setup do
    game_code = Utils.generate_game_code()
    {:ok, _pid} = Server.start_link(game_code)
    {:ok, %{game_code: game_code}}
  end

  describe "add_player/2" do
    test "adds a player to the game instance", %{game_code: game_code} do
      player = Player.new("p1")

      {:ok, _} = Server.add_player(game_code, player)
      {:ok, %{players: [player]}} = Server.get_game(game_code)
    end
  end
end
