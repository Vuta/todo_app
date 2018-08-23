defmodule TodoApp.Auth.UserTest do
  use TodoApp.DataCase
  alias TodoApp.Auth
  alias TodoApp.Auth.User

  @valid_attrs %{
    email: "test@example.com",
    full_name: "User 1",
    password: "123456",
    password_confirmation: "123456"
  }

  @invalid_attrs %{}

  test "registration changeset with valid attrs" do
    user = User.registration_changeset(%User{}, @valid_attrs)
    assert user.valid?
  end

  test "registration changeset with invalid attrs" do
    user = User.registration_changeset(%User{}, @invalid_attrs)
    refute user.valid?
  end

  test "password attr must be at least 6 chars" do
    min_pass = %{@valid_attrs | password: "12345"}
    user_1 = User.registration_changeset(%User{}, min_pass)

    refute user_1.valid?
    assert %{password: ["should be at least 6 character(s)"]} = errors_on(user_1)
  end

  test "password attr must be at most 100 chars" do
    max_pass = %{@valid_attrs | password: String.duplicate("1", 101)}
    user_2 = User.registration_changeset(%User{}, max_pass)

    refute user_2.valid?
    assert %{password: ["should be at most 100 character(s)"]} = errors_on(user_2)
  end

  test "email must be in correct format" do
    invalid_email = %{@valid_attrs | email: "abcd@mail"}
    user = User.registration_changeset(%User{}, invalid_email)

    refute user.valid?
    assert %{email: ["has invalid format"]} = errors_on(user)
  end

  test "email must be unique" do
    Auth.registration_user(@valid_attrs)
    {:error, dup_email} = Auth.registration_user(@valid_attrs)

    refute dup_email.valid?
    assert %{email: ["has already been taken"]} = errors_on(dup_email)
  end

  test "password will be encrypted" do
    {:ok, user} = Auth.registration_user(@valid_attrs)

    assert user.encrypted_password != "123456"
    assert Comeonin.Argon2.checkpw("123456", user.encrypted_password)
  end
end
