defmodule ShutTheBox.Game.Server do
  @moduledoc """
  Manages a game's state
  """

  use GenServer

  # External API

  def start_link(game_code) do
    GenServer.start_link(__MODULE__, game_code, name: {:global, game_code})
  end

  # GenServer Callbacks

  def init(_game_id) do
    {:ok, %{}}
  end

  def game_pid(game_code) do
    GenServer.whereis({:global, game_code})
  end
end
