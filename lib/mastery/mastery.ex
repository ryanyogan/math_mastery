defmodule Mastery do
  alias Mastery.Boundary.{QuizSession, QuizManager}
  alias Mastery.Boundary.{TemplateValidator, QuizValidator}
  alias Mastery.Core.Quiz

  @doc """
  Use to start a new `QuizManager` GenServer which will
  create a link to the caller.

  A single `QuizManager` will be spawned, unlike the `SessionManager`
  which is dynamic per user session, the `QuizManager` stores
  all the global `Quiz` state.
  """
  def start_quiz_manager do
    GenServer.start_link(QuizManager, %{}, name: QuizManager)
  end

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
         {:ok, session} <- GenServer.start_link(QuizSession, {quiz, email}),
         do: session,
         else: (error -> error)
  end

  def select_question(session) do
    GenServer.call(session, :select_question)
  end

  def answer_question(session, answer) do
    GenServer.call(session, {:answer_question, answer})
  end
end
