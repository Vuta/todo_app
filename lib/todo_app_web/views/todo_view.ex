defmodule TodoAppWeb.TodoView do
  use TodoAppWeb, :view

  def item_status(item) do
    case item.completed do
      false -> "active"
      true -> "completed"
    end
  end

  def item_status_class(item) do
    case item.completed do
      false -> "label label-danger"
      true -> "label label-info"
    end
  end
end
