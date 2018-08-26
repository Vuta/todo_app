defmodule TodoAppWeb.Api.V1.TodoView do
  use TodoAppWeb, :view

  def render("todos.json", %{todos: todos}) do
    %{todos: render_many(todos, TodoAppWeb.Api.V1.TodoView, "todo.json")}
  end

  def render("todo.json", %{todo: todo}) do
    %{id: todo.id, name: todo.name}
  end

  def render("items.json", %{todo: todo, items: items}) do
    %{
      id: todo.id,
      todo: todo.name,
      items: render_many(items, TodoAppWeb.Api.V1.TodoView, "item.json", as: :item)
    }
  end

  def render("item.json", %{item: item}) do
    %{id: item.id, content: item.content, completed: item.completed}
  end
end
