defmodule Games.CLI do
  @moduledoc """
    The Games.CLI module has a main function which calls Games.Menu.display()

    Games.CLI gets called by the projects/0 in mix.exs
  """

  @doc """
  The main/1 function calls Games.Menu.display()
  Although it takes a keyword list as argument -- in order to fulfil its contract with escript --, it doesn't use it.
  """
  @spec main(keyword()) :: :ok
  def main(_args) do
    Games.Menu.display()
  end
end
