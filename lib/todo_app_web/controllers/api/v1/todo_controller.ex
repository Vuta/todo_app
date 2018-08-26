defmodule TodoAppWeb.Api.V1.TodoController do
  use TodoAppWeb, :controller
  alias TodoApp.{Auth, Todos}

  def index(conn, _params) do
    current_user = Auth.jwt_current_user(conn)
    todos = Todos.list_todos(current_user)

    render conn, "todos.json", todos: todos
  end

  def show(conn, %{"id" => id}) do
    case Todos.get_todo(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> text("Todo not found")
      todo ->
        todo_items = Todos.sort_all_items_of_todo(todo)
        render conn, "items.json", todo: todo, items: todo_items
    end
  end

  def create(conn, %{"todo" => todo_params}) do
    todo_params = Map.put_new(todo_params, "user_id", Auth.jwt_current_user(conn).id)
    case Todos.insert_todo(todo_params) do
      {:ok, todo} ->
        render conn, "todo.json", todo: todo

      {:error, _todo} ->
        conn
        |> put_status(:unprocessable_entity)
        |> text("Invalid params")
    end
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    case Todos.update_todo(id, todo_params) do
      {:ok, todo} ->
        render conn, "todo.json", todo: todo

      {:error, _todo} ->
        conn
        |> put_status(:unprocessable_entity)
        |> text("Invalid params")
    end
  end

  def delete(conn, %{"id" => id}) do
    case Todos.get_todo(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> text("Todo not found")

      todo ->
        Todos.delete_todo(todo)
        conn
        |> put_status(:ok)
        |> text("Todo deleted")
    end
  end
end
