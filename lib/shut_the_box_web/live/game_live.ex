defmodule ShutTheBoxWeb.GameLive do
  alias ShutTheBox.Game.Server
  alias ShutTheBoxWeb.Endpoint
  use ShutTheBoxWeb, :live_view

  def mount(_params, %{"player_id" => player_id} = _session, socket) do
    {:ok, put_private(socket, :player_id, player_id)}
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :player_id, "Spectator")}
  end

  def handle_params(%{"game_code" => game_code}, _uri, socket) do
    if connected?(socket), do: Endpoint.subscribe("game:#{game_code}")

    {:ok, %{players: players}} = Server.get_game(game_code)

    {:noreply, assign(socket, :players, players)}
  end

  def handle_info(%{event: "players_updated", payload: %{players: players}}, socket) do
    {:noreply, assign(socket, :players, players)}
  end

  def render(assigns) do
    ~H"""
    <div>
      GAME LIVE
      <p>
        player_id: <%= @socket.private[:player_id] %>
      </p>

      <%= for p <- @players do %>
        <p><%= p.name %></p>
      <% end %>
    </div>
    """
  end
end
