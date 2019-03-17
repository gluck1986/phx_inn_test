defmodule PhxWeb.FallbackController do
  use PhxWeb, :controller

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:forbidden)
    |> render(PhxWeb.ErrorView, :"403")
  end
end
