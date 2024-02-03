defmodule ShutTheBoxWeb.GameController do
  use ShutTheBoxWeb, :controller

  alias ShutTheBox.Game.{Player, Supervisor, Utils}

  def create(conn, %{"name" => name} = _params) do
    game_code = Utils.generate_game_code()
    {:ok, _} = Supervisor.start_game(game_code)
    player = Player.new(name)
    # {:ok, _} = Server.add_player(player)

    conn
    |> put_session(:player_id, player.id)
    |> put_flash(:info, "Welcome, #{player.name}!")
    |> redirect(to: ~p"/game/#{game_code}")
  end
end
