defmodule ShutTheBoxWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use ShutTheBoxWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # The default endpoint for testing
      @endpoint ShutTheBoxWeb.Endpoint

      use ShutTheBoxWeb, :verified_routes

      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import ShutTheBoxWeb.ConnCase
    end
  end

  setup tags do
    ShutTheBox.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  Setup helper to make a game with a player

      setup :make_game_with_player

  Returned conn has player's id in session
  """
  def make_game_with_player(%{conn: conn}) do
    game_code = ShutTheBox.Game.Utils.generate_game_code()
    {:ok, _} = ShutTheBox.Game.Supervisor.start_game(game_code)
    player = ShutTheBox.Game.Player.new("p1")
    ShutTheBox.Game.Server.add_player(game_code, player)

    %{
      conn: give_session_to_player(conn, player),
      game_code: game_code,
      player: player
    }
  end

  @doc """
  Puts the player's id on the session
  """
  def give_session_to_player(conn, player) do
    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:player_id, player.id)
  end
end
