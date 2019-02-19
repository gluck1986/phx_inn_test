defmodule PhxWeb.RoomChannelTest do
  use PhxWeb.ChannelCase
  #import Ecto.Query

  #  setup do
  #    {:ok, _, socket} =
  #      socket(PhxWeb.UserSocket, "user_id", %{some: :assign})
  #      |> subscribe_and_join(PhxWeb.RoomChannel, "room:inn")
  #
  #    {:ok, socket: socket}
  #  end

  setup do
    {:ok, _, socket} =
      socket(PhxWeb.UserSocket, "user_id", %{some: :assign})
      |> subscribe_and_join(PhxWeb.RoomChannel, "room:inn")

    {:ok, socket: socket}
  end

  ##
  ##  test "ping replies with status ok", %{socket: socket} do
  ##    ref = push socket, "ping", %{"hello" => "there"}
  ##    assert_reply ref, :ok, %{"hello" => "there"}
  ##  end
  ##
  ##  test "shout broadcasts to room:lobby", %{socket: socket} do
  ##    push socket, "shout", %{"hello" => "all"}
  ##    assert_broadcast "shout", %{"hello" => "all"}
  ##  end
  ##
  ##  test "broadcasts are pushed to the client", %{socket: socket} do
  ##    broadcast_from! socket, "broadcast", %{"some" => "data"}
  ##    assert_push "broadcast", %{"some" => "data"}
  ##  end

  test "new_inn broadcasts to room:inn", %{socket: socket} do
    push(socket, "new_inn", %{"body" => "all"})
    broadcast_from! socket, "error", %{"body" => "ИНН должен состоять из чисел и иметь 10 или 12 занков"}
    push socket, "new_inn", %{"body" => "6449013711"}
    broadcast_from! socket, "result", %{"body" => "6449013718"}
    ## assert_push "new_inn", %{"body" => "64490137"}
    #    ref = push(socket, "new_inn", %{"body" => "v"})
    #    assert_broadcast "new_inn", %{"body" => "6449013711"}
    #    ##assert_push "new_inn", %{"body" => "6449013711"}
#        inn_check = Phx.InnCheck
#        |> Phx.Repo.count()
#inn_check  = Phx.Repo.one(from p in Phx.InnCheck, select: count("*"))
#        assert inn_check ===1
#        assert inn_check.inn === "6449013711"
  end
end
