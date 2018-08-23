defmodule TodoAppWeb.RegistrationControllerTest do
  use TodoAppWeb.ConnCase
  alias TodoApp.Repo
  alias TodoApp.Auth.User


  @valid_attr %{
    "email" => "test@example.com",
    "full_name" => "Mr P. Enis",
    "password" => "123456",
    "password_confirmation" => "123456"
  }
  describe "create/2" do
    test "create new user with valid attr", %{conn: conn} do
      response = post(conn, registration_path(conn, :create), %{"registration" => @valid_attr})

      assert html_response(response, 302) =~ ~r/redirected/
      assert get_flash(response, :info) =~ ~r/successfully/
      assert Repo.get_by(User, email: "test@example.com")
    end
  end
end
