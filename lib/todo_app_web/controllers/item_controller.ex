defmodule TodoAppWeb.ItemController do
  use TodoAppWeb, :controller
  alias TodoApp.{Repo, Item, Todo}

  def new(conn, %{"todo_id" => todo_id}) do
    todo = get_todo(todo_id)
    item_changeset = Item.changeset(%Item{}, %{})

    render conn, "new.html", item_changeset: item_changeset, todo: todo
  end

  def create(conn, %{"todo_id" => todo_id, "item" => item_params}) do
    todo = get_todo(todo_id)
    item =
      todo
      |> Ecto.build_assoc(:items, item_params)
      |> Item.changeset(item_params)

    case Repo.insert(item) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "New Item Added")
        |> redirect(to: todo_path(conn, :show, todo))
      {:error, item_changeset} ->
        render conn, "new.html", item_changeset: item_changeset, todo: todo
    end
  end

  def delete(conn, %{"todo_id" => todo_id, "id" => id}) do
    todo = get_todo(todo_id)
    item = Repo.get(Item, id)
    Repo.delete(item)

    conn
    |> put_flash(:info, "Item Removed")
    |> redirect(to: todo_path(conn, :show, todo))
  end

  def update_status(conn, %{"todo_id" => todo_id, "item_id" => id}) do
    todo = get_todo(todo_id)
    item = Repo.get(Item, id)

    item_changeset = Item.changeset(item, %{completed: !item.completed})

    Repo.update(item_changeset)
    conn
    |> put_flash(:info, "Item Status Updated")
    |> redirect(to: todo_path(conn, :show, todo))
  end

  defp get_todo(todo_id), do: Repo.get(Todo, todo_id)
end
