defmodule PhxWeb.RoomChannelTest do
  use PhxWeb.ChannelCase

  setup do
    {:ok, _, socket} =
      socket(PhxWeb.UserSocket, "user_id", %{some: :assign})
      |> subscribe_and_join(PhxWeb.RoomChannel, "room:inn")

    {:ok, socket: socket}
  end

  test "new_inn broadcasts to room:inn", %{socket: socket} do
    push(socket, "new_inn", %{"body" => "all"})

    broadcast_from!(socket, "error", %{
      "body" => "ИНН должен состоять из чисел и иметь 10 или 12 занков"
    })

    push(socket, "new_inn", %{"body" => "6449013711"})
    broadcast_from!(socket, "result", %{"body" => "6449013718"})
  end
end
