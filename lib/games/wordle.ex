defmodule Games.Wordle do
  @moduledoc """
  In Wordle, the user tries to guess a five-letter word by entering a guess.

  The game will give feedback on the guess, and the user will have six attempts to guess the correct word.
  """
  @words "priv/words.txt"
  @type color :: :green | :yellow | :grey
  @type wordle :: {[String.t() | color], [String.t() | color]}

  @doc """
  Starts the Wordle game, asks for user input, handles invalid user input, and loops until the game has finished.

  Arguments:
      answer: a string, defaulting to a randomly chosen from a list of nearly 15,000 5-letter words
      attempt: an integer, defaulting to 0, that gets incremented for each incorrect guess, and if it reaches 6, user loses the game.
  """
  @spec play(String.t(), integer()) :: :ok
  def play(answer \\ Enum.random(get_text(@words)), attempt \\ 0)

  def play(answer, 6) do
    """
    😞 You lose. After 6 attempts, you have not guessed the correct answer.
    Correct answer: \"#{answer}\".
    """
    |> IO.puts()
  end

  def play(answer, attempt) do
    guess = IO.gets("Enter a five letter word: ") |> String.trim()

    cond do
      guess == answer ->
        feedback_list = feedback(answer, guess)
        IO.puts(color_feedback(guess, feedback_list))
        IO.puts("You win!")

      String.length(guess) == String.length(answer) ->
        feedback_list = feedback(answer, guess)
        IO.puts(color_feedback(guess, feedback_list))
        play(answer, attempt + 1)

      true ->
        IO.puts("You entered the wrong number of letters.\n")
        play(answer, attempt)
    end
  end

  @doc """
  Returns a list of words from file at path.
  """
  @spec get_text(String.t()) :: [String.t()]
  def get_text(path) when is_binary(path) do
    File.stream!(path)
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
  end

  @doc """
  Uses IO.ANSI to create colored feedback for a guess.

  ## Examples
      iex> Games.Wordle.color_feedback("toast", [:green, :yellow, :grey, :yellow, :yellow])
      "\e[32mt\e[39m\e[33mo\e[39m\e[90ma\e[39m\e[33ms\e[39m\e[33mt\e[39m"
  """
  @spec color_feedback(String.t(), [color]) :: String.t()
  def color_feedback(guess, feedback_list) do
    guess_list = String.split(guess, "", trim: true)

    Enum.zip([guess_list, feedback_list])
    |> Enum.map_join(fn
      {letter, :green} -> IO.ANSI.green() <> letter <> IO.ANSI.default_color()
      {letter, :yellow} -> IO.ANSI.yellow() <> letter <> IO.ANSI.default_color()
      {letter, :grey} -> IO.ANSI.light_black() <> letter <> IO.ANSI.default_color()
    end)
  end

  @doc """
  Compares an answer with a guess.

  Returns a wordle list where:
    - Exact matches get represented as ```:green```.
    - Matches in the wrong location get represented as ```:yellow``` (prioritizing first appearances).
    - Non-matches get represented as ```:grey```.

  Case insensitive.

  NOTE: ```feedback/2``` does not handle invalid input errors. Don't call it directly; use ```play/2``` instead.

  ## Examples
      iex> Games.Wordle.feedback("foo", "oFf")
      [:yellow, :yellow, :grey]
      iex> Games.Wordle.feedback("green", "grnne")
      [:green, :green, :yellow, :grey, :yellow]
      iex> Games.Wordle.feedback("great", "green")
      [:green, :green, :green, :grey, :grey]
      iex> Games.Wordle.feedback("ababc", "bbabc")
      [:grey, :green, :green, :green, :green]
  """
  @spec feedback(String.t(), String.t()) :: [color]
  def feedback(answer, guess) do
    {
      answer |> String.downcase() |> String.graphemes(),
      guess |> String.downcase() |> String.graphemes()
    }
    |> match_greens_first()
    |> then_yellows_and_greys()
  end

  @doc """
  Takes a wordle map and compares ```answer``` with ```guess```.

  Returns a wordle map with exact matches represented as ```:green```.

  Intended to get called by ```feedback/2```, with the result piped into ```then_yellows_and_greys/1```.
  """

  @spec match_greens_first({[String.t()], [String.t()]}) :: wordle
  def match_greens_first({answer, guess}) do
    Enum.zip_with(answer, guess, fn
      a, g when a == g -> {:green, :green}
      a, g -> {a, g}
    end)
    |> Enum.unzip()
  end

  @doc """
  Takes a *greenified* wordle map and compares `answer` with `guess`.

  Returns a list built from `guess` that transforms non-`:green`s into `:yellow` or `:grey` as appropriate.

  Intended to get called by `feedback/2`, with the input piped from `match_greens_first/1`.
  """
  @spec then_yellows_and_greys(wordle) :: [color]
  def then_yellows_and_greys({answer, guess}) do
    remaining_letters = for {a, g} <- Enum.zip(answer, guess), is_binary(g), do: a

    {_, result} =
      Enum.reduce(guess, {remaining_letters, []}, fn
        guess_letter_or_atom, {remaining_letters, result} ->
          cond do
            Enum.member?(remaining_letters, guess_letter_or_atom) ->
              {remaining_letters -- [guess_letter_or_atom], [:yellow | result]}

            is_binary(guess_letter_or_atom) ->
              {remaining_letters, [:grey | result]}

            true ->
              {remaining_letters, [guess_letter_or_atom | result]}
          end
      end)

    result |> Enum.reverse()
  end
end
