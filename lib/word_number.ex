defmodule WordNumber do
  @moduledoc """
  Documentation for WordNumber.
  """

  @doc """
  Hello world.

  ## Examples

      iex> WordNumber.hello()
      :world

  """
  def hello do
    :world
  end

  def words_to_number(words) do
    Numbers.words_to_number(words)
  end
end
