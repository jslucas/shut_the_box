defmodule ShutTheBoxWeb.GameLive do
  use ShutTheBoxWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>
      GAME LIVE <%= @player_id %>
    </div>
    """
  end

  def mount(_params, %{"player_id" => player_id} = _session, socket) do
    {:ok, assign(socket, :player_id, player_id)}
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :player_id, "Spectator")}
  end
end
