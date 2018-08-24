defmodule TodoApp.Auth.AuthTest do
  use TodoApp.DataCase
  alias TodoApp.Auth

  @valid_attrs %{
    "email" => "test@example.com",
    "full_name" => "User 1",
    "password" => "123456",
    "password_confirmation" => "123456"
  }

  test "registration_user/1 with valid attr insert a new user" do
    assert {:ok, user} = Auth.registration_user(@valid_attrs)
    assert user.email == "test@example.com"
  end

  test "sign_in/1 will signed user in if user valid" do
    {:ok, registed_user} = Auth.registration_user(@valid_attrs)

    assert {:ok, user} = Auth.sign_in(@valid_attrs)
    assert user.id == registed_user.id
  end

  test "sign_in/1 will return error in if user invalid" do
    Auth.registration_user(@valid_attrs)
    assert {:error, changeset} = Auth.sign_in(%{@valid_attrs | "password" => "12345"})
  end
end
