defmodule HabitsWeb.Router do
  use HabitsWeb, :router
  use Pow.Phoenix.Router
  use PowAssent.Phoenix.Router

  pipeline :api do
    plug :accepts, ["json"]
    plug HabitsWeb.APIAuthPlug, otp_app: :habits
  end

  pipeline :skip_csrf_protection do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: HabitsWeb.APIAuthErrorHandler
  end

  pipeline :browser do
    plug :accepts, ["html"]
  end

  scope "/" do
    pipe_through :skip_csrf_protection

    pow_assent_authorization_post_callback_routes()
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
    pow_assent_routes()
  end

  scope "/api", HabitsWeb do
    pipe_through :api

    resources "/registration", RegistrationController, singleton: true, only: [:create]
    resources "/session", SessionController, singleton: true, only: [:create, :delete]
    post "/session/renew", SessionController, :renew
  end

  scope "/api" do
    pipe_through [:api, :protected]

    get "/auth/github/new", HabitsWeb.GithubAuthorizationController, :new
    post "/auth/github/callback", HabitsWeb.GithubAuthorizationController, :callback

    forward "/graphql", Absinthe.Plug,
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
