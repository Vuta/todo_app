defmodule TodoApp.Items.ItemTest do
  use TodoApp.DataCase
  alias TodoApp.Items.Item

  @valid_attrs %{content: "Sample Item", completed: false}
  @invalid_attrs %{}

  test "changeset with valid attrs" do
    item_changeset = Item.changeset(%Item{}, @valid_attrs)
    assert item_changeset.valid?
  end

  test "changeset with invalid attrs" do
    item_changeset = Item.changeset(%Item{}, @invalid_attrs)
    refute item_changeset.valid?
  end
end
