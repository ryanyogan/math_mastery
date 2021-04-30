defmodule QuestionTest do
  use ExUnit.Case
  use QuizBuilders

  test "building chooses substitutions" do
    question = build_question(generators: addition_generators([1], [2]))

    assert question.substitutions == [left: 1, right: 2]
  end

  test "function generators are called" do
    generators = addition_generators(fn -> 42 end, [0])
    substitutions = build_question(generators: generators).substitutions

    assert Keyword.fetch!(substitutions, :left) == generators.left.()
  end

  test "building creates asked question text" do
    question = build_question(generators: addition_generators([1], [2]))

    assert question.asked == "1 + 2"
  end
end
