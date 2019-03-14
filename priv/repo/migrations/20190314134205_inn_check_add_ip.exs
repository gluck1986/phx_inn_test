defmodule Phx.Repo.Migrations.InnCheckAddIp do
  use Ecto.Migration

  def change do
    alter table(:inn_check) do
      add :ip, :string, size: 127, null: true
    end
  end
end
