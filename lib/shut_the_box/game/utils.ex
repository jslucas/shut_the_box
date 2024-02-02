defmodule ShutTheBox.Game.Utils do
  def generate_game_code() do
    {l, r} =
      :crypto.strong_rand_bytes(18)
      |> Base.url_encode64()
      |> String.replace(~r/[^a-zA-Z0-9]/, "")
      |> String.upcase()
      |> binary_part(0, 8)
      |> String.split_at(4)

    "#{l}-#{r}"
  end
end
