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
end
