defmodule ShutTheBox.Game.Supervisor do
  @moduledoc """
  Dynamically starts a game server
  """

  use DynamicSupervisor

  alias ShutTheBox.Game.Server

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(nil) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @spec start_game(String.t()) :: {:ok, pid()} | {:error, {:already_started, pid()}}
  def start_game(game_code) do
    child_spec = %{
      id: Server,
      start: {Server, :start_link, [game_code]},
      restart: :transient
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def which_children do
    Supervisor.which_children(__MODULE__)
  end
end
