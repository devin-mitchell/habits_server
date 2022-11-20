defmodule Habits.Accounts.User do
  use Ecto.Schema
  use PowAssent.Ecto.UserIdentities.Schema, user: Habits.Users.User

  schema "users" do
    pow_assent_user_identity_fields()

    timestamps()
  end
end
