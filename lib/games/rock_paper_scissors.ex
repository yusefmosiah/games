defmodule Games.RockPaperScissors do
  @moduledoc """
  Contains the logic for a terminal-based Rock Paper Scissors game.
  """

  @doc """
  Starts the Rock Paper Scissors game, asks for user input, handles invalid input, and loops until the game has finished.
  """
  @type play :: :rock | :paper | :scissors
  @spec play :: :ok
  def play do
    ai_play = Enum.random([:rock, :paper, :scissors])

    user_play =
      IO.gets("(rock / paper / scissors): ")
      |> String.trim()
      |> String.downcase()
      |> String.to_atom()

    cond do
      user_play == ai_play ->
        IO.puts("It's a tie!")

      beats?(user_play, ai_play) ->
        IO.puts("You win! #{user_play} beats #{ai_play}.")

      beats?(ai_play, user_play) ->
        IO.puts("You lose! #{ai_play} beats #{user_play}.")

      true ->
        IO.puts("Invalid input. Choose \"rock\", \"paper\", or \"scissors\".")
        play()
    end
  end

  @doc """
  Checks if the first play beats the second play in a game of rock paper scissors.
  """
  @spec beats?(play, play) :: boolean
  def beats?(play1, play2) do
    {play1, play2} in [{:rock, :scissors}, {:scissors, :paper}, {:paper, :rock}]
  end
end
