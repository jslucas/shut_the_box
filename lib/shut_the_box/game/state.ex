defmodule ShutTheBox.Game.State do
  @moduledoc """
  The game struct and interfaces for changing it
  """

  alias ShutTheBox.Game.Player

  defstruct game_code: nil,
            players: []

  @type t :: %__MODULE__{
          game_code: String.t(),
          players: list(Player.t())
        }

  @spec new(String.t()) :: t()
  def new(game_code) do
    struct!(__MODULE__, game_code: game_code)
  end

  @spec add_player(State.t(), Player.t()) :: {:ok, t()}
  def add_player(game, player) do
    {:ok, update_in(game, [Access.key!(:players)], &[player | &1])}
  end
end
