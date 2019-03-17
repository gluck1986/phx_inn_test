defmodule PhxWeb.InnCheckControllerTest do
  use PhxWeb.ConnCase

  alias Phx.InnChecks

  @create_attrs %{inn: "some inn", valid: false, ip: "127.0.0.1"}

  def fixture(:inn_check) do
    {:ok, inn_check} = InnChecks.create_inn_check(@create_attrs)
    inn_check
  end

  def auth(conn, admin \\ false) do
    {:ok, _resource} =
      Phx.Users.create_user(%{
        admin: admin,
        name: "some_name",
        password: "some_pass",
        password_confirmation: "some_pass"
      })

    post(
      conn,
      Routes.session_path(conn, :login, %{
        "user" => %{"username" => "some_name", "password" => "some_pass"}
      })
    )
  end

  describe "index admin" do
    setup [:create_inn_check]

    test "lists all inn_check", %{conn: conn} do
      conn = auth(conn, true)
      conn = get(conn, Routes.inn_check_path(conn, :index))
      response = html_response(conn, 200)
      assert response =~ "Listing Inn check"
      assert response =~ "Заблокировать"
    end
  end

  describe "index operator" do
    setup [:create_inn_check]

    test "lists all inn_check", %{conn: conn} do
      conn = auth(conn, false)
      conn = get(conn, Routes.inn_check_path(conn, :index))
      response = html_response(conn, 200)
      assert response =~ "Listing Inn check"
      assert !(response =~ "Заблокировать")
    end
  end

  describe "lock operator" do
    setup [:create_inn_check]

    test "lock_ip", %{conn: conn} do
      conn = auth(conn, false)

      conn =
        post(conn, Routes.inn_check_path(conn, :lock, %{"ip" => "127.0.0.1", "seconds" => 1}))

      assert get_flash(conn, :error) == "Запрещено"
    end
  end

  describe "lock admin" do
    setup [:create_inn_check]

    test "lock_ip", %{conn: conn} do
      conn = auth(conn, true)

      conn =
        post(conn, Routes.inn_check_path(conn, :lock, %{"ip" => "127.0.0.1", "seconds" => 1}))

      assert get_flash(conn, :info) == "Успешно заблокирован"
    end
  end

  describe "double lock and auto unlock by admin" do
    test "lock_ip", %{conn: conn} do
      conn = auth(conn, true)

      conn =
        post(conn, Routes.inn_check_path(conn, :lock, %{"ip" => "192.168.0.1", "seconds" => 1}))

      assert get_flash(conn, :info) == "Успешно заблокирован"

      conn =
        post(conn, Routes.inn_check_path(conn, :lock, %{"ip" => "192.168.0.2", "seconds" => 1}))

      assert get_flash(conn, :info) == "Успешно заблокирован"

      conn =
        post(conn, Routes.inn_check_path(conn, :lock, %{"ip" => "192.168.0.1", "seconds" => 1}))

      assert get_flash(conn, :error) == "Невозможно"
      Process.sleep(1)

      conn =
        post(conn, Routes.inn_check_path(conn, :lock, %{"ip" => "192.168.0.1", "seconds" => 1}))

      assert get_flash(conn, :info) == "Успешно заблокирован"
    end
  end

  describe "delete inn_check" do
    setup [:create_inn_check]

    test "deletes chosen inn_check", %{conn: conn, inn_check: inn_check} do
      conn = auth(conn)
      conn = delete(conn, Routes.inn_check_path(conn, :delete, inn_check))
      assert redirected_to(conn) == Routes.inn_check_path(conn, :index)
    end
  end

  defp create_inn_check(_) do
    inn_check = fixture(:inn_check)
    {:ok, inn_check: inn_check}
  end
end
