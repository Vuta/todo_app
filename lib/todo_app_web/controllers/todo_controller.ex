defmodule TodoAppWeb.TodoController do
  use TodoAppWeb, :controller
  import TodoAppWeb.AuthController, only: [authenticate: 2]
  plug :authenticate when action in [:new, :create, :show, :delete]

  alias TodoApp.Todos
  alias TodoApp.Todos.Todo
  alias TodoApp.Auth

  def index(conn, _params) do
    todos =
      case Auth.current_user(conn) do
        nil ->
          nil

        user ->
          Todos.list_todos(user)
      end

    render conn, "index.html", todos: todos
  end

  def new(conn, _params) do
    todo_changeset = Todo.changeset(%Todo{}, %{})
    render conn, "new.html", todo_changeset: todo_changeset
  end

  def create(conn, %{"todo" => todo_params}) do
    todo_params = Map.put_new(todo_params, "user_id", Auth.current_user(conn).id)
    case Todos.insert_todo(todo_params) do
      {:ok, todo} ->
        conn
        |> put_flash(:info, "Todo #{todo.name} added")
        |> redirect(to: todo_path(conn, :show, todo))
      {:error, todo} ->
        render conn, "new.html", todo_changeset: todo
    end
  end

  def show(conn, %{"id" => id}) do
    case Todos.get_todo(id) do
      nil ->
        conn
        |> put_flash(:error, "Todo not found")
        |> redirect(to: todo_path(conn, :index))
      todo ->
        todo_items = Todos.sort_all_items_of_todo(todo)
        render conn, "show.html", todo: todo, todo_items: todo_items
    end
  end

  def delete(conn, %{"id" => id}) do
    todo = Todos.get_todo(id)
    Todos.delete_todo(todo)

    conn
    |> put_flash(:info, "Todo #{todo.name} Deleted")
    |> redirect(to: todo_path(conn, :index))
  end
end
