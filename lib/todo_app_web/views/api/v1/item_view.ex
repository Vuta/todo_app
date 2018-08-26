defmodule TodoAppWeb.Api.V1.ItemView do
  use TodoAppWeb, :view

  def render("item.json", %{item: item}) do
    %{content: item.content, completed: item.completed}
  end
end
