defmodule Phx.Services.Redis do
  @pool_size 5

  def child_spec(_args) do
    # Specs for the Redix connections.
    uri = Application.get_env(:phx, Phx.Services.Redis)[:uri]
    opts = Redix.URI.opts_from_uri(uri)

    children =
      for i <- 0..(@pool_size - 1) do
        Supervisor.child_spec({Redix, Keyword.merge([name: :"redix_#{i}"], opts)}, id: {Redix, i})
      end

    # Spec for the supervisor that will supervise the Redix connections.
    %{
      id: RedixSupervisor,
      type: :supervisor,
      start: {Supervisor, :start_link, [children, [strategy: :one_for_one]]}
    }
  end

  def command(command) do
    Redix.command(:"redix_#{random_index()}", command)
  end

  def pipeline(command) do
    Redix.pipeline(:"redix_#{random_index()}", command)
  end

  defp random_index() do
    rem(System.unique_integer([:positive]), @pool_size)
  end
end
