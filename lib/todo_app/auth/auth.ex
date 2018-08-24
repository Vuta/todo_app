defmodule TodoApp.Auth do
  @moduledoc false

  alias TodoApp.Repo
  alias TodoApp.Auth.User

  def sign_in(user_params) do
    user = Repo.get_by(User, email: user_params["email"])
    case user && Comeonin.Argon2.checkpw(user_params["password"], user.encrypted_password) do
      true ->
        {:ok, user}

      _ ->
        {:error, User.changeset(%User{}, user_params)}
    end
  end

  def sign_out(conn) do
    Plug.Conn.delete_session(conn, :current_user_id)
    Plug.Conn.assign(conn, :current_user, nil)
  end

  def registration_user(user_params) do
    user_changeset = User.registration_changeset(%User{}, user_params)
    Repo.insert(user_changeset)
  end

  def current_user(conn) do
    user = conn.assigns[:current_user]

    case user do
      nil ->
        nil

      user ->
        Repo.get(User, user.id)
    end
  end

  def user_signed_in?(conn) do
    !!current_user(conn)
  end
end
