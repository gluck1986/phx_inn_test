defmodule Phx.RoomChannel do
  use Phoenix.Channel

  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def join("room:inn", _message, socket) do
    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_inn", %{"body" => body}, socket) do
    is_input_valid? = fn body ->
      data = %{body: ""}
      types = %{body: :string}

      changeset =
        Ecto.Changeset.cast({data, types}, %{body: body}, [:body])
        |> Ecto.Changeset.validate_required([:body])
        |> Ecto.Changeset.validate_length(:body, max: 12, min: 10)

      changeset.valid? and Regex.match?(~r/^\d+$/, body)
    end

    if is_input_valid?.(body) do
      case Phx.Services.Inn.check_and_insert!(body) do
        {:ok, inn_check} ->
          broadcast!(socket, "result", %{
            body:
              "[#{inn_check.inserted_at}] #{inn_check.inn} : #{
                if inn_check.valid, do: "валиден", else: "не валиден"
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
end
