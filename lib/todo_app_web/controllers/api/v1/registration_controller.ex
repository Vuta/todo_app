defmodule TodoAppWeb.Api.V1.RegistrationController do
  use TodoAppWeb, :controller
  alias TodoApp.Auth
  alias TodoApp.Guardian

  def create(conn, %{"registration" => user_params}) do
    with {:ok, user} <- Auth.registration_user(user_params),
      {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
        render conn, "jwt.json", jwt: token
    end
  end
end
