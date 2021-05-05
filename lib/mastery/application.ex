defmodule Mastery.Application do
  @moduledoc false

  use Application
  alias Mastery.Boundary.QuizManager

  @impl true
  def start(_type, _args) do
    children = [
      {QuizManager, [name: QuizManager]}
    ]

    opts = [strategy: :one_for_one, name: Mastery.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
