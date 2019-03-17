defmodule PhxWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:inn", _message, socket) do
    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in(
        "new_inn",
        %{"body" => body},
        %{assigns: %{ip: ip}} = socket
      ) do
    alias Phx.Services.Ip

    is_input_valid? = fn body ->
      data = %{body: ""}
      types = %{body: :string, ip: :string}

      changeset =
        Ecto.Changeset.cast({data, types}, %{body: body}, [:body])
        |> Ecto.Changeset.validate_required([:body])
        |> Ecto.Changeset.validate_length(:body, max: 12, min: 10)

      changeset.valid? and Regex.match?(~r/^\d+$/, body)
    end

    cond do
      Ip.is_lock?(ip) ->
        broadcast!(socket, "error", %{body: "Вам запрещено данное действие"})

      is_input_valid?.(body) ->
        case Phx.Services.Inn.check_and_insert!(
               body,
               Ip.ip_to_string(ip)
             ) do
          {:ok, inn_check} ->
            broadcast!(socket, "result", %{
              body:
                "[#{inn_check.inserted_at}] #{inn_check.inn} : #{
                  (inn_check.valid && "Валиден") || "Не валиден"
                } "
            })

          {:error, _changeset} ->
            broadcast!(socket, "error", %{body: "Не известная ошибка"})
        end

      true ->
        broadcast!(socket, "error", %{
          body: "ИНН должен состоять из чисел и иметь 10 или 12 занков"
        })
    end

    {:noreply, socket}
  end
end
