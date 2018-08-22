defmodule TodoApp.Item do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc false

  schema "items" do
    field :content, :string
    field :completed, :boolean

    belongs_to :todo, TodoApp.Todo
    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:content, :completed])
    |> validate_required([:content])
  end
end
