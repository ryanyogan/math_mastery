defmodule Mastery.Core.Quiz do
  @moduledoc """
  The `Quiz` module encapsulates all other modules, this module tracks
  the current question, asked questions, what was answered correctly, and
  incorrectly.

  Mastery of an particular challenge may be defined via the
  `questions_until_mastery`
  """

  defstruct title: nil,
            questions_until_mastery: 3,
            templates: %{},
            used_tempaltes: [],
            current_question: nil,
            last_response: nil,
            correct_answers: %{},
            mastered_templates: []
end
