defmodule PhxWeb.InnCheckController do
  use PhxWeb, :controller

  alias Phx.InnChecks

  def index(conn, _params) do
    inn_check = InnChecks.list_inn_check_ordered(desc: :inserted_at)
    render(conn, "index.html", inn_check: inn_check)
  end

  def lock(conn, %{"ip" => ip, "seconds" => seconds}) do
    case Phx.Services.Ip.validate(ip, seconds) do
      %{valid?: true} = changeset ->
        Phx.Services.Ip.lock(changeset)

        conn
        |> put_flash(:info, "Успешно заблокирован")
        |> redirect(to: Routes.inn_check_path(conn, :index))

      %{valid?: false} ->
        conn
        |> put_flash(:error, "Невозможно")
        |> redirect(to: Routes.inn_check_path(conn, :index))
    end
  end

  def delete(conn, %{"id" => id}) do
    inn_check = InnChecks.get_inn_check!(id)
    {:ok, _inn_check} = InnChecks.delete_inn_check(inn_check)

    conn
    |> put_flash(:info, "Inn check deleted successfully.")
    |> redirect(to: Routes.inn_check_path(conn, :index))
  end
end
