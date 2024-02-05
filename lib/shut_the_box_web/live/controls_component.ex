defmodule ShutTheBoxWeb.ControlsComponent do
  use Phoenix.LiveComponent
  import ShutTheBoxWeb.CoreComponents, only: [button: 1]

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="grid grid-rows-1">
      <div class="mx-auto">
        <%= unless Enum.empty?(@roll) do %>
          <div>
            <p><%= Enum.at(@roll, 0) %>, <%= Enum.at(@roll, 1) %></p>
          </div>
        <% end %>
        <%= if @turn.step == :waiting_to_start do %>
          <.button phx-disable-with="Starting..." phx-click="start_game">Start Game</.button>
        <% end %>
        <%= if @turn.player_id == @player_id do %>
          <%= if @turn.step == :roll do %>
            <.button phx-click="roll">Roll</.button>
          <% end %>
        <% end %>
        <%= if @turn.step == :close_tiles && !Enum.empty?(@tiles_to_close) do %>
          <.button phx-click="close_tiles">Close tiles</.button>
        <% end %>
      </div>
    </div>
    """
  end
end
