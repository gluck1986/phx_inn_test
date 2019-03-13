defmodule Phx.Users.User do
  import Bcrypt
  import Ecto.Changeset
  use Ecto.Schema

  schema "users" do
    field :admin, :boolean, default: false
    field :name, :string
    field :pass_hash, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :password, :password_confirmation, :admin])
    |> validate_required([:name, :password, :password_confirmation])
    |> validate_confirmation(:password)
    |> hash_password()
  end

  def hash_password(%Ecto.Changeset{changes: %{password: password}} = changeset)
      when password !== nil do
    change(changeset, add_hash(password, hash_key: :pass_hash))
    |> change(%{password_confirmation: nil})
  end

  def hash_password(changeset), do: changeset
end
