defmodule PhxWeb.InnCheckControllerTest do
  use PhxWeb.ConnCase

  alias Phx.InnChecks

  @create_attrs %{inn: "some inn", valid: false, ip: "127.0.0.1"}
  @invalid_attrs %{inn: nil}

  def fixture(:inn_check) do
    {:ok, inn_check} = InnChecks.create_inn_check(@create_attrs)
    inn_check
  end

  describe "index" do
    test "lists all inn_check", %{conn: conn} do
      conn = get(conn, Routes.inn_check_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Inn check"
    end
  end

  describe "delete inn_check" do
    setup [:create_inn_check]

    test "deletes chosen inn_check", %{conn: conn, inn_check: inn_check} do
      conn = delete(conn, Routes.inn_check_path(conn, :delete, inn_check))
      assert redirected_to(conn) == Routes.inn_check_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.inn_check_path(conn, :show, inn_check))
      end
    end
  end

  defp create_inn_check(_) do
    inn_check = fixture(:inn_check)
    {:ok, inn_check: inn_check}
  end
end
