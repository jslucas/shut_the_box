defmodule ShutTheBox.Game.UtilsTest do
  use ExUnit.Case
  alias ShutTheBox.Game.Utils

  describe "generate_game_code/1" do
    test "generates a string of 8 characters hyphenated in the middle" do
      assert Regex.match?(~r/^[A-Z0-9]{4}-[A-Z0-9]{4}$/, Utils.generate_game_code())
    end
  end
end
