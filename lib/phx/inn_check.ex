defmodule Phx.InnCheck do
  @moduledoc false
  use Ecto.Schema

  schema "inn_check" do
    field :inn, :string
    field :valid, :boolean
    field :ip, :string
    timestamps()
  end

  def changeset(inn_check, params \\ %{}) do
    inn_check
    |> Ecto.Changeset.cast(params, [:inn, :valid, :ip])
    |> Ecto.Changeset.validate_required([:inn, :valid])
    |> Ecto.Changeset.validate_length(:inn, max: 12)
  end
end
