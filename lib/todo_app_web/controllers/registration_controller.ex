defmodule TodoAppWeb.RegistrationController do
  use TodoAppWeb, :controller
  alias TodoApp.Auth
  alias TodoApp.Auth.User

  def new(conn, _params) do
    user_changeset = User.registration_changeset(%User{}, %{})
    render conn, "new.html", user_changeset: user_changeset
  end

  def create(conn, %{"registration" => user_params}) do
    case Auth.registration_user(user_params) do
      {:ok, user} ->
        conn
        |> assign(:current_user, user)
        |> put_session(:current_user_id, user.id)
        |> configure_session(renew: true)
        |> put_flash(:info, "You have successfully signed up!")
        |> redirect(to: todo_path(conn, :index))

      {:error, user_changeset} ->
        render conn, "new.html", user_changeset: user_changeset
    end
  end
end
