defmodule TodoAppWeb.Api.V1.RegistrationView do
  use TodoAppWeb, :view

  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end
end
