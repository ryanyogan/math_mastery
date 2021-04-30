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

  alias Mastery.Core.Template

  @doc """
  New takes a template in which it will evaluate the given generators
  by using the substitions, compile, and evaluate.
  """
  def new(%Template{} = template) do
    template.generators
    |> Enum.map(&build_substitution/1)
    |> evaluate(template)
  end

  defp build_substitution({name, choices_or_generator_fn}) do
    {name, choose(choices_or_generator_fn)}
  end

  defp choose(choices) when is_list(choices) do
    Enum.random(choices)
  end

  defp choose(generator_fn) when is_function(generator_fn) do
    generator_fn.()
  end

  defp evaluate(substitutions, template) do
    %__MODULE__{
      asked: compile(template, substitutions),
      substitutions: substitutions,
      template: template
    }
  end

  defp compile(template, substitutions) do
    template.compiled
    |> Code.eval_quoted(assigns: substitutions)
    |> elem(0)
  end
end
