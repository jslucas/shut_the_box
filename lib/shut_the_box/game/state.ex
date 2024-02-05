defmodule ShutTheBox.Game.State do
  @moduledoc """
  The game struct and interfaces for changing it
  """

  alias ShutTheBox.Game.Player

  defstruct game_code: nil,
            players: [],
            turn_order: nil,
            turn: %{step: :waiting_to_start, player_id: nil},
            roll: []

  @type t :: %__MODULE__{
          game_code: String.t(),
          players: list(Player.t()),
          turn_order: list(String.t()) | nil,
          turn: map(),
          roll: list(integer())
        }

  @spec new(String.t()) :: t()
  def new(game_code) do
    struct!(__MODULE__, game_code: game_code)
  end

  @spec add_player(State.t(), Player.t()) :: {:ok, t()}
  def add_player(game, player) do
    {:ok, update_in(game, [Access.key!(:players)], &[player | &1])}
  end

  def start_game(game) do
    turn_order = Enum.map(game.players, & &1.id) |> Enum.shuffle()
    turn = %{step: :roll, player_id: Enum.at(turn_order, 0)}

    {:ok, Map.merge(game, %{turn_order: turn_order, turn: turn})}
  end

  def roll(game) do
    roll = [:rand.uniform(6), :rand.uniform(6)]

    {:ok, Map.merge(game, %{roll: roll})}
  end
end
