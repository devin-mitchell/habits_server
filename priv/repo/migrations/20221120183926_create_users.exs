defmodule Habits.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :provider, :string, null: false
      add :uid, :string, null: false
      add :user_id, references("users", on_delete: :nothing)

      timestamps()
    end

    create unique_index(:users, [:uid, :provider])
  end
end
