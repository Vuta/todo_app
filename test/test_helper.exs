ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(TodoApp.Repo, :manual)

ExUnit.configure(exclude: [error_view_case: true])
