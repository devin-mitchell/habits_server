defmodule HabitsWeb.GithubAuthorizationController do
  use HabitsWeb, :controller

  alias PowAssent.Plug

  def new(conn, _params) do
    conn
    |> Plug.authorize_url("github", redirect_uri(conn))
    |> case do
      {:ok, url, conn} ->
        json(conn, %{data: %{url: url, session_params: conn.private[:pow_assent_session_params]}})

      {:error, _error, conn} ->
        conn
        |> put_status(500)
        |> json(%{error: %{status: 500, message: "An unexpected error occurred"}})
    end
  end

  defp redirect_uri(_conn) do
    "http://localhost:4000/auth/github/callback"
  end

  def callback(conn, %{"provider" => "github"} = params) do
    session_params = Map.fetch!(params, "session_params")

    IO.inspect(session_params)

    params = Map.drop(params, ["session_params"])

    conn
    |> put_private(:pow_assent_sessions_params, session_params)
    |> Plug.callback_upsert("github", params, redirect_uri(conn))
    |> case do
      {:ok, conn} ->
        json(conn, %{
          data: %{
            access_token: conn.private.api_access_token,
            renewal_token: conn.private.api_renewal_token
          }
        })

      {:error, conn} ->
        conn
        |> put_status(500)
        |> json(%{error: %{status: 500, message: "An unexpected error occurred"}})
    end
  end
end
