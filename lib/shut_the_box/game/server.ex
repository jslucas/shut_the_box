defmodule ShutTheBox.Game.Server do
  @moduledoc """
  Manages a game's state and publishes updates
  """
  alias ShutTheBox.Game.{Player, State}
  alias ShutTheBoxWeb.Endpoint

  use GenServer

  # External API

  def start_link(game_code) do
    GenServer.start_link(__MODULE__, game_code, name: {:global, game_code})
  end

  @spec add_player(String.t(), Player.t()) :: {:ok, State.t()}
  def add_player(game_code, player) do
    game_pid = GenServer.whereis({:global, game_code})

    GenServer.call(game_pid, {:add_player, player})
    |> publish_players_updated()
  end

  def get_game(game_code) do
    game_pid = GenServer.whereis({:global, game_code})

    GenServer.call(game_pid, {:get_state})
  end

  def start_game(game_code) do
    game_pid = GenServer.whereis({:global, game_code})

    GenServer.call(game_pid, {:start_game})
    |> publish_game_started()
  end

  def roll(game_code) do
    game_pid = GenServer.whereis({:global, game_code})

    GenServer.call(game_pid, {:roll})
    |> publish_roll_updated()
    |> publish_turn_updated()
  end

  def close_tiles(game_code, tiles_to_close) do
    game_pid = GenServer.whereis({:global, game_code})

    GenServer.call(game_pid, {:close_tiles, tiles_to_close})
    |> publish_turn_updated()
  end

  # GenServer Callbacks

  def init(game_code) do
    {:ok, State.new(game_code)}
  end

  def handle_call({:get_state}, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:add_player, player}, _from, state) do
    state = State.add_player(state, player)

    {:reply, {:ok, state}, state}
  end

  def handle_call({:start_game}, _from, state) do
    state = State.start_game(state)

    {:reply, {:ok, state}, state}
  end

  def handle_call({:roll}, _from, state) do
    state = State.roll(state)

    {:reply, {:ok, state}, state}
  end

  def handle_call({:close_tiles, tiles_to_close}, _from, state) do
    state = State.close_tiles(state, tiles_to_close)

    {:reply, {:ok, state}, state}
  end

  def publish_players_updated({:ok, state} = result) do
    Endpoint.broadcast("game:#{state.game_code}", "players_updated", %{players: state.players})
    result
  end

  def publish_game_started({:ok, state} = result) do
    Endpoint.broadcast("game:#{state.game_code}", "game_started", %{
      turn_order: state.turn_order,
      turn: state.turn
    })

    result
  end

  def publish_roll_updated({:ok, state} = result) do
    Endpoint.broadcast("game:#{state.game_code}", "roll_updated", %{roll: state.roll})
    result
  end

  def publish_turn_updated({:ok, state} = result) do
    Endpoint.broadcast("game:#{state.game_code}", "turn_updated", %{turn: state.turn})
    result
  end

  def game_pid(game_code) do
    GenServer.whereis({:global, game_code})
  end
end
