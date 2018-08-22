defmodule TodoApp.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset
  alias TodoApp.Todos.Todo
  alias TodoApp.Items.Item

  @moduledoc false

  schema "todos" do
    field :name, :string

    has_many :items, Item
    timestamps()
  end

  @doc false
  def changeset(%Todo{} = todo, attrs) do
    todo
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, max: 128)
  end
end
