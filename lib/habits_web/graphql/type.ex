defmodule HabitsWeb.GraphQL.Type do
  use Absinthe.Relay.Schema.Notation, :modern
  use Absinthe.Schema.Notation

  import_types(HabitsWeb.GraphQL.Types.User)
end
