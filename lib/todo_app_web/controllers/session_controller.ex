defmodule TodoAppWeb.SessionController do
  use TodoAppWeb, :controller
  alias TodoApp.Auth
  alias TodoApp.Auth.User

  def new(conn, _params) do
    session_changeset = User.changeset(%User{}, %{})
    render conn, "new.html", session_changeset: session_changeset
  end

  def create(conn, %{"session" => user_params}) do
    case Auth.sign_in(user_params) do
      {:ok, user} ->
        conn
        |> assign(:current_user, user)
        |> put_session(:current_user_id, user.id)
        |> configure_session(renew: true)
        |> put_flash(:info, "You have successfully signed in!")
        |> redirect(to: todo_path(conn, :index))

      {:error, session_changeset} ->
        conn
        |> put_flash(:error, "Invalid Email/Password")
        |> render("new.html", session_changeset: session_changeset)
    end
  end

  def delete(conn, _params) do
    conn
    |> Auth.sign_out()
    |> put_flash(:info, "I'll miss you, please comeback :(")
    |> redirect(to: todo_path(conn, :index))
  end
end
