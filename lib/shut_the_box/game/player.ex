defmodule ShutTheBox.Game.Player do
  defstruct [:id, :name, :tiles]

  @type t :: %__MODULE__{
          id: UUID.uuid4(),
          name: String.t(),
          tiles: %{integer() => boolean()}
        }

  def new(name) do
    struct!(__MODULE__, %{
      id: Uniq.UUID.uuid6(),
      name: name,
      tiles: Map.new(1..9, fn k -> {k, true} end)
    })
  end
end
