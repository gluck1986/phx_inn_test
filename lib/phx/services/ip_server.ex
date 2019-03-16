defmodule Phx.Services.IpServer do
  use GenServer
  @key Application.get_env(:phx, Phx.Services.IpChildren)[:storage_key]
  @rate Application.get_env(:phx, Phx.Services.IpChildren)[:rate]

  def init(state) do
    process()
    {:ok, state}
  end

  def handle_cast({:process}, state) do
    Phx.Services.Redis.command(["ZREMRANGEBYSCORE", @key, "-inf", System.system_time(:second)])
    Process.sleep(@rate)
    process()
    {:noreply, state}
  end

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  defp process() do
    GenServer.cast(__MODULE__, {:process})
  end

  def is_lock?(ip) when is_integer(ip) do
    case Phx.Services.Redis.command(["ZSCORE", @key, ip]) do
      {:ok, nil} -> false
      {:ok, _} -> true
    end
  end

  def lock(ip, seconds) when is_integer(ip) and is_integer(seconds) do
    time = System.system_time(:second) + seconds

    case false === is_lock?(ip) and Phx.Services.Redis.command(["zadd", @key, time, ip]) do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end
end
