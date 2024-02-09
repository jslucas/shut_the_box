defmodule ShutTheBoxWeb.TilesComponent do
  use Phoenix.LiveComponent

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto w-full flex space-x-1 max-w-xl mb-4">
      <%= for {num, is_open} <- @tiles do %>
        <div
          phx-click={if @turn.step == :close_tiles && is_open, do: "toggle_to_close"}
          phx-value-tile={num}
          data-test={"#{num}-tile"}
          class="bg-yellow-600/50 border-2 border-yellow-800/20 w-full min-w-28 h-28 relative"
        >
          <div class="absolute inset-x-0 top-0">
            <p class={"text-center text-6xl #{if Enum.member?(@tiles_to_close, to_string(num)), do: "text-stone-200"}"}>
              <%= if is_open do %>
                <%= num %>
              <% else %>
                X
              <% end %>
            </p>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end
