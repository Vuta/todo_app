defmodule TodoApp.ItemsTest do
  use TodoApp.DataCase
  alias TodoApp.{Todos, Items}
  alias TodoApp.Items.Item

  @valid_attrs %{content: "Sample Item", completed: false}
  @valid_todo_attrs %{name: "Sample Todo"}

  test "insert_item/2 with valid attrs inserts an item" do
    {:ok, todo} = Todos.insert_todo(@valid_todo_attrs)

    assert {:ok, %Item{} = item} = Items.insert_item(@valid_attrs, todo)
    assert item.content == "Sample Item"
    assert item.completed == false
  end

  test "get_item/1 returns an item" do
    {:ok, todo} = Todos.insert_todo(@valid_todo_attrs)
    {:ok, item} = Items.insert_item(@valid_attrs, todo)

    assert item = Items.get_item(item.id)
  end

  test "delete_item/1 deletes an item" do
    {:ok, todo} = Todos.insert_todo(@valid_todo_attrs)
    {:ok, item} = Items.insert_item(@valid_attrs, todo)

    assert {:ok, item} = Items.delete_item(item)
  end

  test "update_item_status/1 toggles item status" do
    {:ok, todo} = Todos.insert_todo(@valid_todo_attrs)
    {:ok, item} = Items.insert_item(@valid_attrs, todo)
    {:ok, updated_item} = Items.update_item_status(item)

    assert item.completed == !updated_item.completed
  end
end
