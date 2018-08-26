defmodule TodoAppWeb.Api.V1.ItemController do
  use TodoAppWeb, :controller
  alias TodoApp.{Todos, Items}

  def show(conn, %{"id" => id}) do
    case Items.get_item(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> text("Item not found")

      item ->
        render conn, "item.json", item: item
    end
  end

  def create(conn, %{"todo_id" => todo_id, "item" => item_params}) do
    todo = Todos.get_todo(todo_id)

    case Items.insert_item(item_params, todo) do
      {:ok, item} ->
        render conn, "item.json", item: item

      {:error, _} ->
        conn
        |> put_status(:unprocessable_entity)
        |> text("Invaild params")
    end
  end

  def update(conn, %{"id" => id, "item_params" => item_params}) do
    case Items.update_item(id, item_params) do
      {:ok, item} ->
        render conn, "item.json", item: item

      {:error, _} ->
        conn
        |> put_status(:unprocessable_entity)
        |> text("Invaild params")
    end
  end

  def update_status(conn, %{"item_id" => item_id}) do
    item = Items.get_item(item_id)
    case Items.update_item_status(item) do
      {:ok, item} ->
        render conn, "item.json", item: item

      {:error, _} ->
        conn
        |> put_status(:unprocessable_entity)
        |> text("Invalid")
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Items.get_item(id)

    case Items.delete_item(item) do
      {:ok, _} ->
        conn
        |> put_status(:ok)
        |> text("Item deleted")

      {:error, _} ->
        conn
        |> put_status(:unprocessable_entity)
        |> text("Invalid")
    end
  end
end
