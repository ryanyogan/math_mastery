defmodule Mastery do
  alias Mastery.Boundary.{QuizSession, QuizManager}
  alias Mastery.Boundary.{TemplateValidator, QuizValidator}
  alias Mastery.Core.Quiz

  @doc """
  `Mastery.build_quiz/1` creates a new `Quiz` which is placed in the
  state of the `QuizManager`

  Calling this function also validates the required fields are provided.
  """
  def build_quiz(quiz_fields) do
    with :ok <- QuizValidator.errors(quiz_fields),
         :ok <- GenServer.call(QuizManager, {:build_quiz, quiz_fields}),
         do: :ok,
         else: (error -> error)
  end

  def add_template(title, template_fields) do
    with :ok <- TemplateValidator.errors(template_fields),
         :ok <- GenServer.call(QuizManager, {:add_template, title, template_fields}),
         do: :ok,
         else: (error -> error)
  end

  def take_quiz(title, email) do
    with %Quiz{} = quiz <- QuizManager.lookup_quiz_by_title(title),
         {:ok, _} <- QuizSession.take_quiz(quiz, email),
         do: {title, email},
         else: (error -> error)
  end

  def select_question(name) do
    QuizSession.select_question(name)
  end

  def answer_question(name, answer) do
    QuizSession.answer_question(name, answer)
  end
end
