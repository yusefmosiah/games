defmodule Games.Menu do
  @moduledoc """
  The Games.Menu module provides a menu by which the user may select which game to play.
  """

  @doc """
  The Games.Menu.display() function displays a menu of games and calls the appropriate game module.
  """
  @spec display :: :ok
  def display do
    output = """
    Select a game:
    1. Guessing Game
    2. Rock Paper Scissors
    3. Wordle
    """

    IO.puts(output)
    {selected_game, _rest} = IO.gets("Select: ") |> Integer.parse()

    case selected_game do
      1 -> Games.GuessingGame.play()
      2 -> Games.RockPaperScissors.play()
      3 -> Games.Wordle.play()
    end
  end
end
