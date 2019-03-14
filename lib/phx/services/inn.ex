defmodule Phx.Services.Inn do
  @doc """
    check what inn string is valid, by control number
  """
  @spec valid?(string()) :: boolean()
  def valid?(inn) do
    valid?(:list, String.graphemes(inn))
  end

  @spec valid?(:list, list()) :: boolean()
  defp valid?(:list, inn) when length(inn) === 10 do
    k = [2, 4, 10, 3, 5, 9, 4, 6, 8]
    [head | tail] = Enum.reverse(inn)
    last = String.to_integer(head)

    Enum.reverse(tail)
    |> valid?(k, last)
  end

  @spec valid?(:list, list()) :: boolean()
  defp valid?(:list, inn) when length(inn) === 12 do
    k10 = [7, 2, 4, 10, 3, 5, 9, 4, 6, 8]
    k11 = [3, 7, 2, 4, 10, 3, 5, 9, 4, 6, 8]
    [last | tail11] = Enum.reverse(inn)
    [pre_last | tail10] = tail11

    valid?(Enum.reverse(tail10), k10, String.to_integer(pre_last)) &&
      valid?(Enum.reverse(tail11), k11, String.to_integer(last))
  end

  defp valid?(:list, _inn) do
    false
  end

  @doc """
     check what inn list is valid, by control number
    iex> list =   ["6", "4", "4",  "9", "0", "1", "3", "7", "1"]
    iex> k_list = [2, 4, 10, 3, 5, 9, 4, 6, 8]
    iex> last = 1
    iex> true = valid?(list, k_list, last)
  """

  @spec valid?(list(), list(), integer()) :: boolean()
  defp valid?(list, k_list, last) do
    Enum.map(list, &String.to_integer(&1))
    |> Enum.zip(k_list)
    |> Enum.reduce(0, fn {digit, k}, acc -> k * digit + acc end)
    |> (&abs(&1 - div(&1, 11) * 11)).()
    |> (&if(&1 == 10, do: 0, else: &1)).()
    |> (&(&1 == last)).()
  end

  @doc """
     check what inn list is valid, by control number
     and try to insert inn and check result as new Phx.InnCheck db record
  """
  @spec check_and_insert!(string(), string()) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def check_and_insert!(inn_string, ip) do
    is_inn_valid = Phx.Services.Inn.valid?(inn_string)
    inn = %Phx.InnCheck{}
    inn_changeset = Phx.InnCheck.changeset(inn, %{inn: inn_string, valid: is_inn_valid, ip: ip})
    Phx.Repo.insert(inn_changeset)
  end
end
