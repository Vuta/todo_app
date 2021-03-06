defmodule TodoAppWeb.ItemControllerTest do
  use TodoAppWeb.ConnCase
  import Ecto.Query
  alias TodoApp.{Repo, Todos, Items}
  alias TodoApp.Items.Item

  test "requires authentication on these action", %{conn: conn} do
    Enum.each([
      post(conn, todo_item_path(conn, :create, "123"), %{}),
      delete(conn, todo_item_path(conn, :delete, "123", "321"), %{}),
      put(conn, todo_item_update_status_path(conn, :update_status, "1", "12"), %{})
    ], fn(conn) ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  describe "create/2" do
    setup [:insert_todo_and_item]
    setup [:signed_in]
    @tag signed_in_as: "gau gau ranger"
    test "creates new item and redirect to todo page if attr is valid", %{conn: conn, todo: todo} do
      item_params = %{"todo_id" => todo.id, "item" => %{content: "First Item"}}
      response = post(conn, todo_item_path(conn, :create, todo), item_params)

      assert html_response(response, 302) =~ ~r/redirected/
      assert response.private[:phoenix_flash]["info"] =~ "New Item Added"
      assert last_item().content == "First Item"
    end

    setup [:signed_in]
    @tag signed_in_as: "gau gau ranger"
    test "responds errors if attr is invalid", %{conn: conn, todo: todo} do
      item_params = %{"todo_id" => todo.id, "item" => %{content: nil}}
      response = post(conn, todo_item_path(conn, :create, todo), item_params)

      assert html_response(response, 200) =~ ~r/New Item/
      assert html_response(response, 200) =~ ~r/Validation failed/
    end
  end

  setup [:signed_in]
  @tag signed_in_as: "gau gau ranger"
  setup [:insert_todo_and_item]
  test "delete/2", %{conn: conn, todo: todo, item: item} do
    item_params = %{"todo_id" => todo.id, "id" => item.id}
    response = delete(conn, todo_item_path(conn, :delete, todo, item), item_params)

    assert html_response(response, 302) =~ ~r/redirected/
    assert get_flash(response, "info") =~ "Item Removed"
    assert Items.get_item(item.id) == nil
  end

  setup [:insert_todo_and_item]
  setup [:signed_in]
  @tag signed_in_as: "gau gau ranger"
  test "update_status", %{conn: conn, todo: todo, item: item} do
    item_params = %{"todo_id" => todo.id, "item_id" => item.id}
    old_status = item.completed

    response = put(conn, todo_item_update_status_path(conn, :update_status, todo, item), item_params)

    assert html_response(response, 302) =~ ~r/redirected/
    assert get_flash(response, "info") =~ "Item Status Updated"
    assert Items.get_item(item.id).completed == !old_status
  end

  defp insert_todo_and_item(_) do
    {:ok, todo} = Todos.insert_todo(%{name: "Sample Todo"})
    {:ok, item} = Items.insert_item(%{content: "Sample Item"}, todo)

    {:ok, todo: todo, item: item}
  end

  defp last_item do
    Item |> last |> Repo.one
  end
end
