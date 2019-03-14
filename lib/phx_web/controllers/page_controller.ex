defmodule PhxWeb.PageController do
  use PhxWeb, :controller
  import Ecto.Query

  def index(conn, _params) do
    checks =
      Phx.InnChecks.InnCheck
      |> order_by(desc: :inserted_at)
      |> Phx.Repo.all()

    render(conn, "index.html",
      checks:
        Enum.map(
          checks,
          &%{
            inn: &1.inn,
            inserted_at: &1.inserted_at,
            valid:
              case &1.valid do
                true -> "Валиден"
                false -> "Не валиден"
              end
          }
        )
    )
  end
end
