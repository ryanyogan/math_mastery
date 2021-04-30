defmodule Mastery.Core.Template do
  @moduledoc """
  A `Template` holds all the data to build a question, generators
  run substitutions and will either pick a random element from a list
  or use a supplied generator function.
  """
  defstruct [
    :name,
    :category,
    :instructions,
    :raw,
    :compiled,
    :generators,
    :checker
  ]
end
