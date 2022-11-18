defmodule HabitsWeb.GraphQL.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  import_types(HabitsWeb.GraphQL.Type)

  query do
    import_fields(:user_query)
  end
end
