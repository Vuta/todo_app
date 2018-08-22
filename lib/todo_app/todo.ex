defmodule TodoApp.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc false

  schema "todos" do
    field :name, :string

    has_many :items, TodoApp.Item
    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, max: 128)
  end
end
