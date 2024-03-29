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

  @spec next_step(t()) :: t()
  def next_step(turn) do
    Map.put(turn, :step, next(turn.step))
  end

  defp next(:waiting_to_start), do: :roll
  defp next(:roll), do: :close_tiles
  defp next(:close_tiles), do: :roll

  @spec close_tiles(t(), list(integer())) :: {:ok, t()} | {:error, String.t()}
  def close_tiles(turn, tiles_to_close) do
    closing_tiles_that_are_already_closed =
      Enum.any?(tiles_to_close, fn to_close -> !turn.tiles[to_close] end)

    unless closing_tiles_that_are_already_closed do
      tiles =
        for {num, is_open} <- turn.tiles, into: %{} do
          if Enum.member?(tiles_to_close, num) do
            {num, false}
          else
            {num, is_open}
          end
        end

      {:ok, Map.merge(turn, %{step: next(turn.step), tiles: tiles})}
    else
      {:error, "Invalid tile selection"}
    end
  end

  @spec open_tiles(t()) :: list(Integer)
  def open_tiles(turn) do
    Map.reject(turn.tiles, fn {_num, is_open} -> !is_open end) |> Map.keys()
  end
end
