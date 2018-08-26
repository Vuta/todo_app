defmodule TodoApp.Auth do
  @moduledoc false

  alias TodoApp.Repo
  alias TodoApp.Auth.User
  alias TodoApp.Guardian

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
    conn
    |> Plug.Conn.delete_session(:current_user_id)
    |> Plug.Conn.assign(:current_user, nil)
  end

  def registration_user(user_params) do
    user_changeset = User.registration_changeset(%User{}, user_params)
    Repo.insert(user_changeset)
  end

  def current_user(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)

    case user_id do
      nil ->
        nil

      user_id ->
        Repo.get(User, user_id)
    end
  end

  def user_signed_in?(conn) do
    !!current_user(conn)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def token_sign_in(user_params) do
    user = Repo.get_by(User, email: user_params["email"])
    case user && Comeonin.Argon2.checkpw(user_params["password"], user.encrypted_password) do
      true ->
        Guardian.encode_and_sign(user)

      _ ->
        {:error, :unauthorized}
    end
  end

  def jwt_current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end
end
