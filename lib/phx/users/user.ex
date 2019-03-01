defmodule Phx.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :admin, :boolean, default: false
    field :name, :string
    field :pass_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :pass_hash, :admin])
    |> validate_required([:name, :pass_hash, :admin])
  end
end
