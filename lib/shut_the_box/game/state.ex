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

  @spec add_player(State.t(), Player.t()) :: t()
  def add_player(game, player) do
    Map.update!(game, :players, &[player | &1])
  end

  @spec start_game(State.t()) :: t()
  def start_game(game) do
    turn_order = Enum.map(game.players, & &1.id) |> Enum.shuffle()
    turn = %{step: :roll, player_id: Enum.at(turn_order, 0)}

    Map.merge(game, %{turn_order: turn_order, turn: turn})
  end

  @spec roll(State.t()) :: t()
  def roll(game) do
    roll = [:rand.uniform(6), :rand.uniform(6)]

    Map.merge(game, %{roll: roll})
  end
end
