defmodule TodoAppWeb.Api.V1.SessionView do
  use TodoAppWeb, :view

  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end
end
