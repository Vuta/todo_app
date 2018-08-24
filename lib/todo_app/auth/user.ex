defmodule TodoApp.Auth.User do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias TodoApp.Todos.Todo


  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :full_name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    timestamps()

    has_many :todos, Todo
  end

  @doc false
  def changeset(user, attrs) do
    email_format = ~r/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    user
    |> cast(attrs, [:email, :full_name])
    |> validate_required([:email, :full_name])
    |> validate_format(:email, email_format)
    |> unique_constraint(:email)
  end

  def registration_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:password], [])
    |> validate_required(:password)
    |> validate_length(:password, min: 6, max: 100)
    |> validate_confirmation(:password)
    |> encrypted_password()
  end

  defp encrypted_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :encrypted_password, Comeonin.Argon2.hashpwsalt(password))

      _ ->
        changeset
    end
  end
end
