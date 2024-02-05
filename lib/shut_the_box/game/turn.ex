defmodule ShutTheBox.Game.Turn do
  alias Uniq.UUID

  defstruct [:step, :player_id, :tiles]

  @type t :: %__MODULE__{
          step: term(),
          player_id: nil | UUID,
          tiles: %{integer() => boolean()}
        }

  def new() do
    struct!(__MODULE__, %{
      step: :waiting_to_start,
      player_id: nil,
      tiles: Map.new(1..9, fn k -> {k, true} end)
    })
  end

  @spec update_player_id(t(), UUID) :: t()
  def update_player_id(turn, id) do
    Map.put(turn, :player_id, id)
  end

  @spec next_step(term()) :: t()
  def next_step(turn) do
    Map.put(turn, :step, next(turn.step))
  end

  defp next(:waiting_to_start), do: :roll
  defp next(:roll), do: :close_tiles
  defp next(:close_tiles), do: :roll
end