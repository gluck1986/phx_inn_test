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
      |> Ecto.Changeset.validate_format(:ip, ~r/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/,
        message: "Не является валидным Ip адресом!"
      )
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

  def lock(ip, seconds) do
    ip
    |> to_ipinteger
    |> IpServer.lock(seconds)
  end

  def is_lock?(ip) do
    ip
    |> to_ipinteger
    |> IpServer.is_lock?()
  end

  def to_string({octet1, octet2, octet3, octet4}) do
    ~s(#{octet1}.#{octet2}.#{octet3}.#{octet4})
  end

  def to_ipinteger(address) when is_binary(address) do
    String.split(address, ".")
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce({}, fn val, acc -> Tuple.append(acc, val) end)
    |> to_ipinteger()
  end

  @doc "Turns an erlang-style IPv4 address (i.e. {192,168,1,1}) to a 32 bit decimal integer"
  def to_ipinteger({octet1, octet2, octet3, octet4}) do
    round(octet1 * :math.pow(256, 3) + octet2 * :math.pow(256, 2) + octet3 * 256 + octet4)
  end

  @doc "Turns a 32 bit decimal integer into an IPv4 address (i.e. 4-tuple {192,168,1,1})"
  def to_ipaddress(address) when is_integer(address) do
    [24, 16, 8, 0]
    |> Enum.map(fn x -> address >>> x &&& 0xFF end)
    |> List.to_tuple()
  end
end
