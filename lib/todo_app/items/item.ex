defmodule TodoApp.Items.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias TodoApp.Items.Item
  alias TodoApp.Todos.Todo

  @moduledoc false

  schema "items" do
    field :content, :string
    field :completed, :boolean

    belongs_to :todo, Todo
    timestamps()
  end

  @doc false
  def changeset(%Item{} = item, attrs) do
    item
    |> cast(attrs, [:content, :completed])
    |> validate_required([:content])
  end
end
