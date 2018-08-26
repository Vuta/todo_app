defmodule TodoAppWeb.Api.V1.SessionController do
  use TodoAppWeb, :controller
  alias TodoApp.Auth

  def create(conn, %{"session" => user_params}) do
    case Auth.token_sign_in(user_params) do
      {:ok, token, _claims} ->
        render conn, "jwt.json", jwt: token

      {:error, :unauthorized} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid Login"})
    end
  end
end
