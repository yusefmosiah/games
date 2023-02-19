defmodule Games.WordleTest do
  use ExUnit.Case
  alias Games.Wordle
  doctest Games.Wordle

  test "all green" do
    assert Wordle.feedback("games", "games") == [:green, :green, :green, :green, :green]
  end

  test "all yellow" do
    assert Wordle.feedback("games", "aesmg") == [:yellow, :yellow, :yellow, :yellow, :yellow]
  end

  test "green and yellow" do
    assert Wordle.feedback("games", "mages") == [:yellow, :green, :yellow, :green, :green]
  end

  test "green and grey" do
    assert Wordle.feedback("plays", "point") == [:green, :grey, :grey, :grey, :grey]
  end

  test "yellow and grey" do
    assert Wordle.feedback("rogmt", "tainh") == [:yellow, :grey, :grey, :grey, :grey]
    assert Wordle.feedback("zyobx", "vaxue") == [:grey, :grey, :yellow, :grey, :grey]
    assert Wordle.feedback("games", "smile") == [:yellow, :yellow, :grey, :grey, :yellow]
  end

  test "all colors" do
    assert Wordle.feedback("games", "maxes") == [:yellow, :green, :grey, :green, :green]
  end

  test "duplicate Wordle.feedback/2" do
    assert Wordle.feedback("aaaaa", "bbaaa") == [:grey, :grey, :green, :green, :green]
    assert Wordle.feedback("baaab", "ababa") == [:yellow, :yellow, :green, :yellow, :yellow]
    assert Wordle.feedback("bbcab", "debbc") == [:grey, :grey, :yellow, :yellow, :yellow]
    assert Wordle.feedback("llama", "alarm") == [:yellow, :green, :green, :grey, :yellow]
    assert Wordle.feedback("meeow", "moowm") == [:green, :yellow, :grey, :yellow, :grey]
    assert Wordle.feedback("ababc", "bbabc") == [:grey, :green, :green, :green, :green]
  end
end
