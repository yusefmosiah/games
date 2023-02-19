defmodule Games.GuessingGame do
  @moduledoc """
  In Guessing Game, the user tries to guess a number between 1 and 10.

  After each guess, the user gets feedback telling them if they guessed correctly, too high, or too low.
  """

  @doc """
  Starts the Guessing Game, asks for user input, handles invalid user input, and loops until the game has finished.
  """
  @spec play :: nil
  def play(answer \\ Enum.random(1..10)) do
    {guess, _rest} = IO.gets("Enter your guess: ") |> Integer.parse()

    result = check(guess, answer)
    IO.puts(result)
    if guess != answer, do: play(answer)
  end

  @doc """
  Checks the user's guess against the AI's answer.
  ## Parameters
      - guess: The user's input, should be a number. Ideally, an integer, but floats work too
      - answer: "The AI": A randomly generated integer between 1 and 10

  ## Examples
      iex> Games.GuessingGame.check(9, 9)
      "Correct!"
      iex> Games.GuessingGame.check(234, 7)
      "Too high!"
      iex> Games.GuessingGame.check(-97.82, 3)
      "Too low!"
  """
  @spec check(integer, integer) :: String.t()
  def check(guess, answer) do
    cond do
      guess == answer ->
        "Correct!"

      guess > answer ->
        "Too high!"

      guess < answer ->
        "Too low!"
    end
  end
end
