defmodule TodoAppWeb.TodoController do
  use TodoAppWeb, :controller
  alias TodoApp.Todos
  alias TodoApp.Todos.Todo

  def index(conn, _params) do
    todos = Todos.list_todos()
    render conn, "index.html", todos: todos
  end

  def new(conn, _params) do
    todo_changeset = Todo.changeset(%Todo{}, %{})
    render conn, "new.html", todo_changeset: todo_changeset
  end

  def create(conn, %{"todo" => todo_params}) do
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
