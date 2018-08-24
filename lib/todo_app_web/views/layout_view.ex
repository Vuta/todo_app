defmodule TodoAppWeb.LayoutView do
  use TodoAppWeb, :view
  import TodoApp.Auth, only: [current_user: 1, user_signed_in?: 1]
end
