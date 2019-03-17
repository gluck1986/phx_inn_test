defmodule Phx.Services.Ip do
  use Bitwise
  alias Phx.Services.IpServer

  def validate(ip, seconds) do
    data = %{ip: "", seconds: nil}
    types = %{ip: :string, seconds: :integer}

    changeset =
      Ecto.Changeset.cast({data, types}, %{ip: ip, seconds: seconds}, [:ip, :seconds])
      |> Ecto.Changeset.validate_required([:ip, :seconds])
      |> Ecto.Changeset.validate_number(:seconds, greater_than: 0)
      |> Ecto.Changeset.validate_number(:seconds, less_than: 9999)
      |> is_lock_validator()

    changeset
  end

  defp is_lock_validator(%Ecto.Changeset{changes: %{ip: ip}} = changeset) do
    case changeset.valid? and is_lock?(ip) do
      true -> Ecto.Changeset.add_error(changeset, :ip, ip <> " уже заблокирован!")
      false -> changeset
    end
  end

  defp is_lock_validator(changeset) do
    changeset
  end

  def lock(%Ecto.Changeset{changes: %{ip: ip, seconds: seconds}}) do
    lock(ip, seconds)
  end

  def lock(ip, seconds) when is_tuple(ip) do
    ip
    |> ip_to_string
    |> IpServer.lock(seconds)
  end

  def lock(ip, seconds) do
    IpServer.lock(ip, seconds)
  end

  def is_lock?(ip) when is_tuple(ip) do
    ip
    |> ip_to_string
    |> IpServer.is_lock?()
  end

  def is_lock?(ip) do
    IpServer.is_lock?(ip)
  end

  def ip_to_string({octet1, octet2, octet3, octet4}) do
    ~s(#{octet1}.#{octet2}.#{octet3}.#{octet4})
  end

  def ip_to_string({octet1, octet2, octet3, octet4, octet5, octet6, octet7, octet8}) do
    ~s(#{Integer.to_string(octet1, 16)}:#{Integer.to_string(octet2, 16)}:#{
      Integer.to_string(octet3, 16)
    }:#{Integer.to_string(octet4, 16)}:#{Integer.to_string(octet5, 16)}:#{
      Integer.to_string(octet6, 16)
    }:#{Integer.to_string(octet7, 16)}:#{Integer.to_string(octet8, 16)})
  end
end
