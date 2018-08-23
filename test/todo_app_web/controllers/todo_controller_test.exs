defmodule TodoAppWeb.TodoControllerTest do
  use TodoAppWeb.ConnCase
  alias TodoApp.{Todos, Items}

  test "requires authentication on these action", %{conn: conn} do
    Enum.each([
      get(conn, todo_path(conn, :show, "123")),
      post(conn, todo_path(conn, :create, %{})),
      delete(conn, todo_path(conn, :delete, "123"))
    ], fn(conn) ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  describe "index/2" do
    setup [:signed_in]
    @tag signed_in_as: "gau gau ranger"
    test "responds with all user's todos if user signed in", %{conn: conn, user: user} do
      todos = [
        %{name: "First Todo", user_id: user.id},
        %{name: "Second Todo", user_id: user.id}
      ]

      [{:ok, todo1}, {:ok, todo2}] = Enum.map(todos, &Todos.insert_todo(&1))

      response = get(conn, todo_path(conn, :index))

      assert String.contains?(response.resp_body, todo1.name)
      assert String.contains?(response.resp_body, todo2.name)
    end
  end


  describe "show/2" do
    setup [:insert_todo_items]
    setup [:signed_in]
    @tag signed_in_as: "gau gau ranger"
    test "responds with todo's detail if todo is found", %{conn: conn, todo: todo, items: items} do
      response = get(conn, todo_path(conn, :show, todo))

      assert html_response(response, 200) =~ todo.name
      assert html_response(response, 200) =~ Enum.at(items, 0).content
      assert html_response(response, 200) =~ Enum.at(items, 1).content
      assert html_response(response, 200) =~ Enum.at(items, 2).content
    end

    setup [:signed_in]
    @tag signed_in_as: "gau gau ranger"
    test "responds with a message indicating that todo not found", %{conn: conn} do
      response = get(conn, todo_path(conn, :show, -1))

      assert html_response(response, 302) =~ ~r/redirected/
      assert response.private[:phoenix_flash]["error"] =~ "Todo not found"
    end
  end

  describe "create/2" do
    setup [:signed_in]
    @tag signed_in_as: "gau gau ranger"
    test "creates new todo and redirect to todo page if attr is valid ", %{conn: conn, user: user} do
      response = post(conn, todo_path(conn, :create, %{"todo" => %{name: "Sample Todo"}}))

      assert List.last(Todos.list_todos(user)).name == "Sample Todo"
      assert html_response(response, 302) =~ ~r/redirected/
    end

    setup [:signed_in]
    @tag signed_in_as: "gau gau ranger"
    test "responds errors if attr is invalid", %{conn: conn} do
      response = post(conn, todo_path(conn, :create, %{"todo" => %{name: nil}}))

      assert html_response(response, 200) =~ ~r/New Todo/
      assert html_response(response, 200) =~ ~r/Validation failed/
    end
  end

  setup [:insert_todo_items]
  setup [:signed_in]
  @tag signed_in_as: "gau gau ranger"
  test "deletes todo", %{conn: conn, todo: todo} do
    response = delete(conn, todo_path(conn, :delete, todo))

    assert html_response(response, 302) =~ ~r/redirected/
    assert Todos.get_todo(todo.id) == nil
  end

  defp insert_todo_items(_) do
    {:ok, todo} = Todos.insert_todo(%{name: "Sample Todo"})
    {:ok, item1} = Items.insert_item(%{content: "First Item"}, todo)
    {:ok, item2} = Items.insert_item(%{content: "Second Item"}, todo)
    {:ok, item3} = Items.insert_item(%{content: "Third Item"}, todo)

    {:ok, todo: todo, items: [item1, item2, item3]}
  end
end
