defmodule TodoApp.Todos do
  @moduledoc """
  Context of Todos
  """
  import Ecto.Query, warn: false
  alias TodoApp.Repo
  alias TodoApp.Todos.Todo

  def list_todos, do: Repo.all(Todo)

  def insert_todo(todo_params) do
    %Todo{}
    |> Todo.changeset(todo_params)
    |> Repo.insert()
  end

  def get_todo(todo_id) do
    todo = Repo.get(Todo, todo_id)
    Repo.preload(todo, :items)
  end

  def delete_todo(todo), do: Repo.delete(todo)

  def sort_all_items_of_todo(todo), do: Enum.sort(todo.items, &(&1.inserted_at >= &2.inserted_at))
end
