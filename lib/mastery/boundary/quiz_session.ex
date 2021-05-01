defmodule Mastery.Boundary.QuizSession do
  use GenServer
  alias Mastery.Core.{Quiz, Response}

  @impl true
  def init({quiz, email}) do
    {:ok, {quiz, email}}
  end

  @impl true
  def handle_call(:select_question, _from, {quiz, email}) do
    quiz = Quiz.select_question(quiz)
    {:reply, quiz.current_question.asked, {quiz, email}}
  end

  @impl true
  def handle_call({:answer_question, answer}, _from, {quiz, email}) do
    res = Response.new(quiz, email, answer)

    quiz
    |> Quiz.answer_question(res)
    |> Quiz.select_question()
    |> maybe_finish(email)
  end

  defp maybe_finish(nil, _email), do: {:stop, :normal, :finished, nil}

  defp maybe_finish(quiz, email) do
    {
      :reply,
      {quiz.current_question.asked, quiz.last_response.is_correct?},
      {quiz, email}
    }
  end
end
