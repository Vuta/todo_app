defmodule TodoAppWeb.AuthController do
  use TodoAppWeb, :controller

  def authenticate(conn, _) do
    case TodoApp.Auth.user_signed_in?(conn) do
      true ->
        conn

      false ->
        conn
        |> put_flash(:error, "You must be signed in to continue.")
        |> redirect(to: todo_path(conn, :index))
        |> halt()
    end
  end
end
