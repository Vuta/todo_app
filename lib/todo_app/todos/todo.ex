defmodule TodoApp.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset
  alias TodoApp.Todos.Todo
  alias TodoApp.Items.Item
  alias TodoApp.Auth.User

  @moduledoc false

  schema "todos" do
    field :name, :string
    timestamps()

    has_many :items, Item
    belongs_to :user, User
  end

  @doc false
  def changeset(%Todo{} = todo, attrs) do
    todo
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name])
    |> validate_length(:name, max: 128)
  end
end
