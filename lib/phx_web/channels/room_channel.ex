defmodule PhxWeb.RoomChannel do
  use Phoenix.Channel

  #  def join("room:lobby", payload, socket) do
  #    if authorized?(payload) do
  #      {:ok, socket}
  #    else
  #      {:error, %{reason: "unauthorized"}}
  #    end
  #  end

  #  # Channels can be used in a request/response fashion
  #  # by sending replies to requests from the client
  #  def handle_in("ping", payload, socket) do
  #    {:reply, {:ok, payload}, socket}
  #  end
  #
  #  # It is also common to receive messages from the client and
  #  # broadcast to everyone in the current topic (room:lobby).
  #  def handle_in("shout", payload, socket) do
  #    broadcast(socket, "shout", payload)
  #    {:noreply, socket}
  #  end

  def join("room:inn", _message, socket) do
    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in(
        "new_inn",
        %{"body" => body},
        socket
      ) do
    ip = socket.assigns.ip
    # broadcast!(socket, "error", %{body: "Не известная ошибка"})
    is_input_valid? = fn body ->
      data = %{body: ""}
      types = %{body: :string, ip: :string}

      changeset =
        Ecto.Changeset.cast({data, types}, %{body: body}, [:body])
        |> Ecto.Changeset.validate_required([:body])
        |> Ecto.Changeset.validate_length(:body, max: 12, min: 10)

      changeset.valid? and Regex.match?(~r/^\d+$/, body)
    end

    if is_input_valid?.(body) do
      case Phx.Services.Inn.check_and_insert!(body, ip) do
        {:ok, inn_check} ->
          broadcast!(socket, "result", %{
            body:
              "[#{inn_check.inserted_at}] #{inn_check.inn} : #{
                if inn_check.valid, do: "Валиден", else: "Не валиден"
              } "
          })

        {:error, _changeset} ->
          broadcast!(socket, "error", %{body: "Не известная ошибка"})
      end
    else
      broadcast!(socket, "error", %{body: "ИНН должен состоять из чисел и иметь 10 или 12 занков"})
    end

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
