defmodule Games.RockPaperScissorsTest do
  use ExUnit.Case

  test "rock beats scissors" do
    assert Games.RockPaperScissors.beats?(:rock, :scissors)
  end

  test "scissors beats paper" do
    assert Games.RockPaperScissors.beats?(:scissors, :paper)
  end

  test "paper beats rock" do
    assert Games.RockPaperScissors.beats?(:paper, :rock)
  end

  test "same play does not beat itself" do
    refute Games.RockPaperScissors.beats?(:rock, :rock)
    refute Games.RockPaperScissors.beats?(:paper, :paper)
    refute Games.RockPaperScissors.beats?(:scissors, :scissors)
  end
end
