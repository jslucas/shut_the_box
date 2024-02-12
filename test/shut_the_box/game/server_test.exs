defmodule ShutTheBox.Game.ServerTest do
  use ExUnit.Case, async: true

  alias ShutTheBoxWeb.Endpoint
  alias ShutTheBox.Game.Player
  alias ShutTheBox.Game.{Player, Server, Utils, Validation}

  setup do
    game_code = Utils.generate_game_code()
    Endpoint.subscribe("game:#{game_code}")

    {:ok, _pid} = Server.start_link(game_code)
    {:ok, %{game_code: game_code, topic: "game:#{game_code}"}}
  end

  describe "add_player/2" do
    test "adds a player to the game instance and publishes", %{game_code: game_code, topic: topic} do
      player = Player.new("p1")

      {:ok, _} = Server.add_player(game_code, player)
      {:ok, %{players: [^player]}} = Server.get_game(game_code)

      assert_receive %{
        topic: ^topic,
        event: "players_updated",
        payload: %{players: [%{name: "p1"}]}
      }
    end
  end

  describe "start_game/1" do
    test "updates turn_order and turn and publishes", %{game_code: game_code, topic: topic} do
      player = Player.new("p1")

      {:ok, _} = Server.add_player(game_code, player)
      {:ok, _} = Server.start_game(game_code)
      assert {:ok, %{turn_order: [_], turn: %{step: :roll}}} = Server.get_game(game_code)
      assert_receive %{topic: ^topic, event: "game_started", payload: %{turn: %{step: :roll}}}
    end
  end

  describe "roll/1" do
    test "sets roll and publishes", %{game_code: game_code, topic: topic} do
      Server.start_game(game_code)
      assert {:ok, _} = Server.roll(game_code)

      assert_receive %{
        topic: ^topic,
        event: "turn_updated",
        payload: %{turn: %{step: :close_tiles}}
      }
    end
  end

  describe "close_tiles/2" do
    test "updates tiles and publishes", %{game_code: game_code, topic: topic} do
      Server.start_game(game_code)
      {:ok, %{roll: roll}} = Server.roll(game_code)

      to_close = Validation.all_tile_combinations(roll) |> Enum.at(0)

      assert {:ok, _} = Server.close_tiles(game_code, to_close)

      assert_receive %{
        topic: ^topic,
        event: "turn_updated",
        payload: %{turn: %{step: :roll, tiles: updated_tiles}}
      }

      for num <- to_close do
        assert !updated_tiles[num]
      end
    end

    test "does not publish if there was an error", %{game_code: game_code, topic: topic} do
      Server.start_game(game_code)
      {:ok, %{roll: roll}} = Server.roll(game_code)
      to_close = Enum.sum(roll) + 1

      assert {:error, _} = Server.close_tiles(game_code, [to_close])

      refute_receive %{
        topic: ^topic,
        event: "turn_updated",
        payload: %{turn: %{step: :roll, tiles: %{^to_close => false}}}
      }
    end
  end
end
