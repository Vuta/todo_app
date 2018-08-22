defmodule TodoApp.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :content, :string
      add :completed, :boolean, default: false
      add :todo_id, references("todos", on_delete: :delete_all)

      timestamps()
    end

  end
end
