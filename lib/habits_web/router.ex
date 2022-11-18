defmodule HabitsWeb.Router do
  use HabitsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api" do
    pipe_through :api

    forward "/", Absinthe.Plug,
      schema: HabitsWeb.GraphQL.Schema,
      context: %{pubsub: HabitsWeb.Endpoint}

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: HabitsWeb.GraphQL.Schema,
      interface: :simple,
      context: %{pubsub: HabitsWeb.Endpoint}
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
