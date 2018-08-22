defmodule TodoAppWeb.TodoController do
  use TodoAppWeb, :controller
  alias TodoApp.{Repo, Todo}

  def index(conn, _params) do
    todos = Repo.all(Todo)
    render conn, "index.html", todos: todos
  end

  def new(conn, _params) do
    todo_changeset = Todo.changeset(%Todo{}, %{})
    render conn, "new.html", todo_changeset: todo_changeset
  end

  def create(conn, %{"todo" => todo_params}) do
    todo_changeset = Todo.changeset(%Todo{}, todo_params)
    case Repo.insert(todo_changeset) do
      {:ok, todo} ->
        conn
        |> put_flash(:info, "Todo #{todo.name} added")
        |> redirect(to: todo_path(conn, :show, todo))
      {:error, todo} ->
        render conn, "new.html", todo_changeset: todo
    end
  end

  def show(conn, %{"id" => id}) do
    todo = Repo.get(Todo, id)
    todo = Repo.preload(todo, :items)

    todo_items = Enum.sort(todo.items, &(&1.inserted_at >= &2.inserted_at))
    render conn, "show.html", todo: todo, todo_items: todo_items
  end

  def delete(conn, %{"id" => id}) do
    todo = Repo.get(Todo, id)
    Repo.delete(todo)

    conn
    |> put_flash(:info, "Todo #{todo.name} Deleted")
    |> redirect(to: todo_path(conn, :index))
  end
end
