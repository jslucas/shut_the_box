defmodule ShutTheBoxWeb.PlayersComponent do
  use Phoenix.LiveComponent

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <%= for p <- @players do %>
        <p><%= p.name %></p>
      <% end %>
    </div>
    """
  end
end
