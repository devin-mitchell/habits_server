defmodule HabitsWeb.GraphQL.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  object :user do
    field :id, non_null(:id)
    field :email, non_null(:string)
  end

  query do
    @desc "information on currently authenticated user"
    field :current_user, :user do
      resolve(fn (_root, _args, _info) -> {:ok, %{id: Ecto.UUID.generate(), email: "test@testing.com"}} end)
    end
  end
end
