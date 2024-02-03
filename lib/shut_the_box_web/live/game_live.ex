defmodule ShutTheBoxWeb.GameLive do
  alias ShutTheBoxWeb.{ControlsComponent, Endpoint, PlayersComponent}
  alias ShutTheBox.Game.Server
  use ShutTheBoxWeb, :live_view

  def mount(_params, %{"player_id" => player_id} = _session, socket) do
    {:ok, put_private(socket, :player_id, player_id)}
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :player_id, "Spectator")}
  end

  def handle_params(%{"game_code" => game_code}, _uri, socket) do
    if connected?(socket), do: Endpoint.subscribe("game:#{game_code}")

    {:ok, game} = Server.get_game(game_code)

    {
      :noreply,
      socket
      |> assign(:game, game)
      |> assign(:game_code, game_code)
    }
  end

  def handle_info(%{event: "players_updated", payload: %{players: players}}, socket) do
    {:noreply, update(socket, :game, &%{&1 | players: players})}
  end

  def handle_info(
        %{event: "game_started", payload: %{turn_order: turn_order, turn: turn}},
        socket
      ) do
    {:noreply, update(socket, :game, &%{&1 | turn_order: turn_order, turn: turn})}
  end

  def handle_event("start_game", _params, socket) do
    {:ok, _} = Server.start_game(socket.assigns.game_code)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="grid">
      <.live_component module={PlayersComponent} id="players-component" players={@game.players} />
      <.live_component
        module={ControlsComponent}
        id="controls-component"
        turn={@game.turn}
        player_id={@socket.private[:player_id]}
      />
    </div>
    """
  end
end
