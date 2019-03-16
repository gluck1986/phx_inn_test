defmodule Phx.Services.IpChildren do
  def child_spec(_args) do
    children = [
      Supervisor.child_spec({Phx.Services.IpServer, name: :ip_server},
        id: {Phx.Services.IpServer, 1}
      )
    ]

    %{
      id: IpChildrenSupervisor,
      type: :supervisor,
      start: {Supervisor, :start_link, [children, [strategy: :one_for_one]]}
    }
  end
end
