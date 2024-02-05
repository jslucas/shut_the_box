defmodule ShutTheBox.Game.Player do
  defstruct [:id, :name, :tiles]

  @type t :: %__MODULE__{
          id: UUID.uuid4(),
          name: String.t()
        }

  def new(name) do
    struct!(__MODULE__, %{
      id: Uniq.UUID.uuid6(),
      name: name
    })
  end
end
