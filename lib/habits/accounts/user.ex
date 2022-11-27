defmodule Habits.Accounts.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  use PowAssent.Ecto.Schema

  alias Habits.Accounts.UserIdentity

  schema "users" do
    has_many :user_identities, UserIdentity

    pow_user_fields()

    timestamps()
  end
end
