defmodule TodoApp.Todos.TodosTest do
  use TodoApp.DataCase
  alias TodoApp.Todos
  alias TodoApp.Todos.Todo
  alias TodoApp.Items

  @valid_attrs %{name: "Sample Todo"}
  @valid_item_attrs %{content: "This is an todo item", completed: false}

  test "insert_todo/1 with valid attr inserts a todo" do
    assert {:ok, %Todo{} = todo} = Todos.insert_todo(@valid_attrs)
    assert todo.name == "Sample Todo"
  end

  test "get_todo/1 returns a todo with items preloaded" do
    {:ok, todo} = Todos.insert_todo(@valid_attrs)
    assert todo = Todos.get_todo(todo.id)
    assert todo.items == []
  end

  test "list_todos/0 returns all todos" do
    {:ok, first_todo} = Todos.insert_todo(@valid_attrs)
    {:ok, second_todo} = Todos.insert_todo(@valid_attrs)

    assert length(Todos.list_todos()) == 2
    assert Todos.list_todos() == [first_todo, second_todo]
  end

  test "delete_todo/1 deleted a todo" do
    {:ok, todo} = Todos.insert_todo(@valid_attrs)
    Todos.delete_todo(todo)
    assert Todos.list_todos() == []
  end

  test "sort_all_items_of_todo/1 returns a list of todo's item sorted by inserted at" do
    {:ok, todo} = Todos.insert_todo(@valid_attrs)
    {:ok, item1} = Items.insert_item(@valid_item_attrs, todo)
    {:ok, item2} = Items.insert_item(@valid_item_attrs, todo)
    {:ok, item3} = Items.insert_item(@valid_item_attrs, todo)

    todo = Todos.get_todo(todo.id)
    assert Todos.sort_all_items_of_todo(todo) == [item3, item2, item1]
  end
end
