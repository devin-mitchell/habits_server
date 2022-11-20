defmodule HabitsWeb.GraphQL.Types.User do
  use Absinthe.Relay.Schema.Notation, :modern
  use Absinthe.Schema.Notation

  object :user_query do
    @desc "information on currently authenticated user"
    field :current_user, :user do
      resolve(fn _root, _args, _info ->
        {:ok, %{id: Ecto.UUID.generate(), email: "test@testing.com"}}
      end)
    end
  end

  object :user do
    field :id, non_null(:id)
    field :email, non_null(:string)
  end
end
