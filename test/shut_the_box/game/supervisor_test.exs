defmodule ShutTheBox.Game.SupervisorTest do
  use ExUnit.Case, async: true

  alias ShutTheBox.Game.{Server, Supervisor}

  describe ".start_game/1" do
    test "spawns and registers a new game server" do
      game_code = "NICE-GAME-1"

      assert {:ok, _pid} = Supervisor.start_game(game_code)

      assert Server.game_pid(game_code)
             |> Process.alive?()
    end

    test "returns :error if already started" do
      game_code = "NICE-GAME-2"

      assert {:ok, pid} = Supervisor.start_game(game_code)
      assert {:error, {:already_started, ^pid}} = Supervisor.start_game(game_code)
    end
  end
end
