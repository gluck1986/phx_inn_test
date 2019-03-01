defmodule Phx.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :pass_hash, :string
      add :admin, :boolean, default: false, null: false

      timestamps()
    end
  end
end
