defmodule Phx.InnChecks do
  @moduledoc """
  The InnChecks context.
  """

  import Ecto.Query, warn: false
  alias Phx.Repo

  alias Phx.InnChecks.InnCheck

  @doc """
  Returns the list of inn_check.

  ## Examples

      iex> list_inn_check()
      [%InnCheck{}, ...]

  """
  def list_inn_check do
    Repo.all(InnCheck)
  end

  def list_inn_check_ordered(order) do
    InnCheck
    |> order_by(^order)
    |> Repo.all()
  end

  @doc """
  Gets a single inn_check.

  Raises `Ecto.NoResultsError` if the Inn check does not exist.

  ## Examples

      iex> get_inn_check!(123)
      %InnCheck{}

      iex> get_inn_check!(456)
      ** (Ecto.NoResultsError)

  """
  def get_inn_check!(id), do: Repo.get!(InnCheck, id)

  @doc """
  Creates a inn_check.

  ## Examples

      iex> create_inn_check(%{field: value})
      {:ok, %InnCheck{}}

      iex> create_inn_check(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_inn_check(attrs \\ %{}) do
    %InnCheck{}
    |> InnCheck.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a inn_check.

  ## Examples

      iex> update_inn_check(inn_check, %{field: new_value})
      {:ok, %InnCheck{}}

      iex> update_inn_check(inn_check, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_inn_check(%InnCheck{} = inn_check, attrs) do
    inn_check
    |> InnCheck.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a InnCheck.

  ## Examples

      iex> delete_inn_check(inn_check)
      {:ok, %InnCheck{}}

      iex> delete_inn_check(inn_check)
      {:error, %Ecto.Changeset{}}

  """
  def delete_inn_check(%InnCheck{} = inn_check) do
    Repo.delete(inn_check)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking inn_check changes.

  ## Examples

      iex> change_inn_check(inn_check)
      %Ecto.Changeset{source: %InnCheck{}}

  """
  def change_inn_check(%InnCheck{} = inn_check) do
    InnCheck.changeset(inn_check, %{})
  end
end
