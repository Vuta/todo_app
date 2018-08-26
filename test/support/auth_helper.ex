defmodule TodoApp.AuthHelper do
  @moduledoc false
  alias TodoApp.Auth

  def user_fixture(attrs \\ %{}) do
    user_atts =
      %{
        "email" => "test-#{Enum.random(1..1_000_000)}@example.com",
        "full_name" => "User-#{Enum.random(1..1_000_000)}",
        "password" => "123456",
        "password_confirmation" => "123456"
      }
      |> Map.merge(attrs)

    Auth.registration_user(user_atts)
  end

  def signed_in(%{conn: conn} = config) do
    if full_name = config[:signed_in_as] do
      {:ok, user} = user_fixture(%{"full_name" => full_name})
      conn =
        conn
        |> Plug.Conn.assign(:current_user, user)
        |> Plug.Test.init_test_session(current_user_id: user.id)

      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end
end
