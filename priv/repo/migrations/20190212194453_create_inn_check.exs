defmodule Phx.Repo.Migrations.CreateInnCheck do
  use Ecto.Migration

  def change do
    create table(:inn_check) do
      add :inn, :string, size: 12
      add :valid, :boolean
      timestamps()
    end
  end
end
