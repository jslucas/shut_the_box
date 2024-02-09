defmodule ShutTheBox.Game.State do
  @moduledoc """
  The game struct and interfaces for changing it
  """

  alias ShutTheBox.Game.{Player, Turn}

  defstruct game_code: nil,
            players: [],
            turn_order: nil,
            turn: Turn.new(),
            roll: []

  @type t :: %__MODULE__{
          game_code: String.t(),
          players: list(Player.t()),
          turn_order: list(String.t()) | nil,
          turn: Turn.t(),
          roll: list(integer())
        }

  @spec new(t()) :: t()
  def new(args) when is_map(args) do
    Map.merge(struct!(__MODULE__), args)
  end

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

    turn = Turn.next_step(game.turn) |> Turn.update_player_id(Enum.at(turn_order, 0))

    Map.merge(game, %{turn_order: turn_order, turn: turn})
  end

  @spec roll(State.t()) :: t()
  def roll(game) do
    roll = [:rand.uniform(6), :rand.uniform(6)]

    Map.merge(game, %{roll: roll, turn: Turn.next_step(game.turn)})
  end

  @spec close_tiles(t(), list(integer())) :: {:ok, t()} | {:error, t(), String.t()}
  def close_tiles(game, tiles_to_close) do
    with {:ok, turn} <- Turn.close_tiles(game.turn, tiles_to_close),
         true <- Enum.sum(tiles_to_close) == Enum.sum(game.roll) do
      {:ok, Map.put(game, :turn, turn)}
    else
      _ -> {:error, "Invalid tile selection"}
    end
  end
end
