defmodule ShutTheBoxWeb.GameLiveTest do
  alias ShutTheBox.Game.Validation
  use ShutTheBoxWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  @endpoint ShutTheBoxWeb.Endpoint

  setup %{conn: conn} do
    %{game_code: game_code, player: player, conn: conn} = make_game_with_player(%{conn: conn})
    {:ok, view, html} = live(conn, ~p"/game/#{game_code}")
    {:ok, %{view: view, html: html, game_code: game_code, player: player}}
  end

  describe "inital state" do
    test "tiles are shown", %{html: html} do
      for num <- 1..9 do
        assert html =~ "data-test=\"#{num}-tile\""
      end
    end

    test "shows players", %{html: html} do
      assert html =~ "p1"
    end

    test "start game button exists", %{html: html} do
      assert html =~ "Start Game"
    end
  end

  describe "gameplay" do
    test "player can roll after starting game", %{view: view} do
      view |> element("button", "Start Game") |> render_click()

      assert render(view) =~ "Roll"
    end

    test "players can close tiles after rolling", %{game_code: game_code, view: view} do
      topic = "game:#{game_code}"
      ShutTheBoxWeb.Endpoint.subscribe("game:#{game_code}")

      view |> element("button", "Start Game") |> render_click()
      view |> element("button", "Roll") |> render_click()

      assert_receive %{topic: ^topic, event: "roll_updated", payload: %{roll: roll}}
      assert_receive %{topic: ^topic, event: "turn_updated", payload: _}

      to_close = Validation.all_tile_combinations(roll) |> Enum.at(0)

      for num <- to_close do
        view |> element("[data-test=#{num}-tile]") |> render_click()
      end

      view |> element("button", "Close tiles") |> render_click()

      assert_receive %{topic: ^topic, event: "turn_updated", payload: %{turn: turn}}

      for num <- to_close do
        assert !turn.tiles[num]
      end
    end
  end
end
