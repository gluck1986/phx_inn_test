defmodule PhxWeb.PageControllerTest do
  use PhxWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Проверка ИНН"
  end
end