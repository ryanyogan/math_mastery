defmodule Mastery.Core.Question do
  @moduledoc """
  The `Question` module represents an instance of a template,
  substitutions will be used in the `Template` generators
  functions.
  """
  defstruct [
    :asked,
    :substitutions,
    :template
  ]
end
