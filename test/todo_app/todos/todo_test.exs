defmodule TodoApp.Todos.TodoTest do
  use TodoApp.DataCase
  alias TodoApp.Todos.Todo

  @valid_attrs %{name: "Sample Todo"}
  @invalid_attrs %{}

  test "changeset with valid attrs" do
    todo_changeset = Todo.changeset(%Todo{}, @valid_attrs)
    assert todo_changeset.valid?
  end

  test "changeset with invalid attrs" do
    todo_changeset = Todo.changeset(%Todo{}, @invalid_attrs)
    refute todo_changeset.valid?
  end

  test "todo name length must be lower than 128 chars" do
    attrs = %{@valid_attrs | name: String.duplicate("a", 129)}
    todo_changeset = Todo.changeset(%Todo{}, attrs)
    assert %{name: ["should be at most 128 character(s)"]} = errors_on(todo_changeset)
  end
end

