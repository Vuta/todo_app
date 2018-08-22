defmodule TodoApp.Items do
  @moduledoc """
  Context of Items
  """
  import Ecto.Query, warn: false
  alias TodoApp.Repo
  alias TodoApp.Items.Item

  def get_item(item_id), do: Repo.get(Item, item_id)

  def insert_item(item_params, todo) do
    todo
    |> Ecto.build_assoc(:items, item_params)
    |> Item.changeset(item_params)
    |> Repo.insert()
  end

  def delete_item(item), do: Repo.delete(item)

  def update_item_status(item) do
    item
    |> Item.changeset(%{completed: !item.completed})
    |> Repo.update()
  end
end
