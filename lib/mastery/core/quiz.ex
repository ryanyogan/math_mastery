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
            used_templates: [],
            current_question: nil,
            last_response: nil,
            correct_answers: %{},
            mastered_templates: []

  alias Mastery.Core.{Template, Question, Response}

  def new(quiz_fields) do
    struct!(__MODULE__, quiz_fields)
  end

  def add_template(quiz, template_fields) do
    template = Template.new(template_fields)

    templates =
      update_in(
        quiz.templates,
        [template.category],
        &add_to_list_or_nil(&1, template)
      )

    %{quiz | templates: templates}
  end

  def select_question(%__MODULE__{templates: t}) when map_size(t) == 0, do: nil

  def select_question(quiz) do
    quiz
    |> pick_current_question()
    |> move_template(:used_templates)
    |> reset_template_cycle()
  end

  def answer_question(quiz, %Response{is_correct?: true} = response) do
    new_quiz =
      quiz
      |> inc_correct_answers()
      |> save_response(response)

    maybe_advance(new_quiz, mastered?(new_quiz))
  end

  def answer_question(quiz, %Response{is_correct?: false} = response) do
    quiz
    |> reset_correct_answers()
    |> save_response(response)
  end

  def save_response(quiz, response) do
    Map.put(quiz, :last_response, response)
  end

  def mastered?(quiz) do
    score = Map.get(quiz.correct_answers, template(quiz).name, 0)
    score == quiz.questions_until_mastery
  end

  def advance(quiz) do
    quiz
    |> move_template(:mastered_templates)
    |> reset_correct_answers()
    |> reset_used_templates()
  end

  defp add_to_list_or_nil(nil, template), do: [template]
  defp add_to_list_or_nil(templates, template), do: [template | templates]

  defp pick_current_question(quiz) do
    Map.put(
      quiz,
      :current_question,
      select_a_random_question(quiz)
    )
  end

  defp select_a_random_question(quiz) do
    quiz.templates
    |> Enum.random()
    |> elem(1)
    |> Enum.random()
    |> Question.new()
  end

  defp move_template(quiz, field) do
    quiz
    |> remove_template_from_category()
    |> add_template_to_field(field)
  end

  defp remove_template_from_category(quiz) do
    template = template(quiz)

    new_category_templates =
      quiz.templates
      |> Map.fetch!(template.category)
      |> List.delete(template)

    new_templates =
      if new_category_templates == [] do
        Map.delete(quiz.templates, template.category)
      else
        Map.put(quiz.templates, template.category, new_category_templates)
      end

    Map.put(quiz, :templates, new_templates)
  end

  defp add_template_to_field(quiz, field) do
    template = template(quiz)
    list = Map.get(quiz, field)

    Map.put(quiz, field, [template | list])
  end

  defp reset_template_cycle(%{templates: templates, used_templates: used_templates} = quiz)
       when map_size(templates) == 0 do
    %__MODULE__{
      quiz
      | templates: Enum.group_by(used_templates, fn template -> template.category end),
        used_templates: []
    }
  end

  defp reset_template_cycle(quiz), do: quiz

  defp inc_correct_answers(%{current_question: question} = quiz) do
    new_correct_answers = Map.update(quiz.correct_answers, question.template.name, 1, &(&1 + 1))
    Map.put(quiz, :correct_answers, new_correct_answers)
  end

  defp maybe_advance(quiz, false = _mastered), do: quiz
  defp maybe_advance(quiz, true = _mastered), do: advance(quiz)

  defp reset_correct_answers(%{current_question: question} = quiz) do
    Map.put(
      quiz,
      :correct_answers,
      Map.delete(quiz.correct_answers, question.template.name)
    )
  end

  defp reset_used_templates(%{current_question: question} = quiz) do
    Map.put(
      quiz,
      :used_templates,
      List.delete(quiz.used_templates, question.template)
    )
  end

  defp template(quiz), do: quiz.current_question.template
end
