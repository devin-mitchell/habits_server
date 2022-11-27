defmodule Habits.Repo.Migrations.DeleteIncorrectUsers do
  use Ecto.Migration

  def change do
    drop table(:users)
  end
end
