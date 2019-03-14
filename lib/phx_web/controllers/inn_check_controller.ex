defmodule PhxWeb.InnCheckController do
  use PhxWeb, :controller

  alias Phx.InnChecks
  alias Phx.InnChecks.InnCheck

  def index(conn, _params) do
    inn_check = InnChecks.list_inn_check()
    render(conn, "index.html", inn_check: inn_check)
  end

  def new(conn, _params) do
    changeset = InnChecks.change_inn_check(%InnCheck{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"inn_check" => inn_check_params}) do
    case InnChecks.create_inn_check(inn_check_params) do
      {:ok, inn_check} ->
        conn
        |> put_flash(:info, "Inn check created successfully.")
        |> redirect(to: Routes.inn_check_path(conn, :show, inn_check))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    inn_check = InnChecks.get_inn_check!(id)
    render(conn, "show.html", inn_check: inn_check)
  end

  def edit(conn, %{"id" => id}) do
    inn_check = InnChecks.get_inn_check!(id)
    changeset = InnChecks.change_inn_check(inn_check)
    render(conn, "edit.html", inn_check: inn_check, changeset: changeset)
  end

  def update(conn, %{"id" => id, "inn_check" => inn_check_params}) do
    inn_check = InnChecks.get_inn_check!(id)

    case InnChecks.update_inn_check(inn_check, inn_check_params) do
      {:ok, inn_check} ->
        conn
        |> put_flash(:info, "Inn check updated successfully.")
        |> redirect(to: Routes.inn_check_path(conn, :show, inn_check))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", inn_check: inn_check, changeset: changeset)
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
