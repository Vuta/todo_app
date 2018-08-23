defmodule TodoAppWeb.SessionControllerTest do
  use TodoAppWeb.ConnCase

  @valid_attr %{"email" => "test@example.com", "password" => "123456"}

  describe "create/2" do
    test "signed in successfully", %{conn: conn} do
      {:ok, user} = user_fixture(@valid_attr)
      response = post(conn, session_path(conn, :create, %{"session" => @valid_attr}))

      assert get_flash(response, :info) =~ ~r/successfully/
      assert html_response(response, 302) =~ ~r/redirected/
      assert response.assigns[:current_user].id == user.id
    end

    test "signed in unsuccessfully", %{conn: conn} do
      response = post(conn, session_path(conn, :create, %{"session" => @valid_attr}))

      assert html_response(response, 200) =~ ~r/Invalid/
      assert response.assigns[:current_user] == nil
    end
  end

  setup [:signed_in]
  @tag signed_in_as: "Donald Duck"
  test "delete/2 signed user out", %{conn: conn} do

    response = delete(conn, session_path(conn, :delete))

    assert html_response(response, 302) =~ ~r/redirected/
    assert get_flash(response, :info) =~ ~r/please comeback/
    assert response.assigns[:current_user] == nil
  end
end
