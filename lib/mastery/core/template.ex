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

  def new(template_fields) do
    raw = Keyword.fetch!(template_fields, :raw)

    struct!(
      __MODULE__,
      Keyword.put(template_fields, :compiled, EEx.compile_string(raw))
    )
  end
end
