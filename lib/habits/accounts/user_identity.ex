defmodule Habits.Accounts.UserIdentity do
  use Ecto.Schema
  use PowAssent.Ecto.UserIdentities.Schema, user: Habits.Accounts.User

  schema "user_identities" do
    pow_assent_user_identity_fields()

    timestamps()
  end
end
