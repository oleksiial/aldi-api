defmodule AldiWeb.StoreControllerTest do
  use AldiWeb.ConnCase

  alias Aldi.Planner
  alias Aldi.Planner.Store

  @create_attrs %{address: "some address", test_id: 42}
  @update_attrs %{address: "some updated address", test_id: 43}
  @invalid_attrs %{address: nil, test_id: nil}

  def fixture(:store) do
    {:ok, store} = Planner.create_store(@create_attrs)
    store
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all stores", %{conn: conn} do
      conn = get conn, store_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create store" do
    test "renders store when data is valid", %{conn: conn} do
      conn = post conn, store_path(conn, :create), store: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, store_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "address" => "some address",
        "test_id" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, store_path(conn, :create), store: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update store" do
    setup [:create_store]

    test "renders store when data is valid", %{conn: conn, store: %Store{id: id} = store} do
      conn = put conn, store_path(conn, :update, store), store: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, store_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "address" => "some updated address",
        "test_id" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, store: store} do
      conn = put conn, store_path(conn, :update, store), store: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete store" do
    setup [:create_store]

    test "deletes chosen store", %{conn: conn, store: store} do
      conn = delete conn, store_path(conn, :delete, store)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, store_path(conn, :show, store)
      end
    end
  end

  defp create_store(_) do
    store = fixture(:store)
    {:ok, store: store}
  end
end
