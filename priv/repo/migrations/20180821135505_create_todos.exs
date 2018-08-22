defmodule TodoApp.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :name, :string

      timestamps()
    end

  end
end
