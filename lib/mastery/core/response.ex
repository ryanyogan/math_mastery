defmodule Mastery.Core.Response do
  @moduledoc """
  The `Response` data structure is a user's "answer" to a particular
  `Question` which is referenced via `question_responded_to`.
  """
  defstruct [
    :quiz_title,
    :template_name,
    :question_responded_to,
    :email,
    :answer,
    :is_correct?,
    :timestamp
  ]

  def new(%{current_question: question, title: title}, email, answer) do
    template = question.template

    %__MODULE__{
      quiz_title: title,
      template_name: template.name,
      question_responded_to: question.asked,
      email: email,
      answer: answer,
      is_correct?: template.checker.(question.substitutions, answer),
      timestamp: DateTime.utc_now()
    }
  end
end
