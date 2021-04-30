defmodule QuestionTest do
  use ExUnit.Case
  use QuizBuilders

  test "building chooses substitutions" do
    question = build_question(generators: addition_generators([1], [2]))

    assert question.substitutions == [left: 1, right: 2]
  end
end
