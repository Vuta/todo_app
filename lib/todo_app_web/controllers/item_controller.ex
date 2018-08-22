defmodule TodoAppWeb.ItemController do
  use TodoAppWeb, :controller
  alias TodoApp.{Items, Todos}
  alias TodoApp.Items.Item

  def new(conn, %{"todo_id" => todo_id}) do
    todo = Todos.get_todo(todo_id)
    item_changeset = Item.changeset(%Item{}, %{})

    render conn, "new.html", item_changeset: item_changeset, todo: todo
  end

  def create(conn, %{"todo_id" => todo_id, "item" => item_params}) do
    todo = Todos.get_todo(todo_id)

    case Items.insert_item(item_params, todo) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "New Item Added")
        |> redirect(to: todo_path(conn, :show, todo))
      {:error, item_changeset} ->
        render conn, "new.html", item_changeset: item_changeset, todo: todo
    end
  end

  def delete(conn, %{"todo_id" => todo_id, "id" => id}) do
    todo = Todos.get_todo(todo_id)
    item = Items.get_item(id)
    Items.delete_item(item)

    conn
    |> put_flash(:info, "Item Removed")
    |> redirect(to: todo_path(conn, :show, todo))
  end

  def update_status(conn, %{"todo_id" => todo_id, "item_id" => id}) do
    todo = Todos.get_todo(todo_id)
    item = Items.get_item(id)
    Items.update_item_status(item)

    conn
    |> put_flash(:info, "Item Status Updated")
    |> redirect(to: todo_path(conn, :show, todo))
  end
end
