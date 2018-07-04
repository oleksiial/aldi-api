defmodule Aldi.PlannerTest do
  use Aldi.DataCase

  alias Aldi.Planner

  describe "stores" do
    alias Aldi.Planner.Store

    @valid_attrs %{address: "some address", test_id: 42}
    @update_attrs %{address: "some updated address", test_id: 43}
    @invalid_attrs %{address: nil, test_id: nil}

    def store_fixture(attrs \\ %{}) do
      {:ok, store} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Planner.create_store()

      store
    end

    test "list_stores/0 returns all stores" do
      store = store_fixture()
      assert Planner.list_stores() == [store]
    end

    test "get_store!/1 returns the store with given id" do
      store = store_fixture()
      assert Planner.get_store!(store.id) == store
    end

    test "create_store/1 with valid data creates a store" do
      assert {:ok, %Store{} = store} = Planner.create_store(@valid_attrs)
      assert store.address == "some address"
      assert store.test_id == 42
    end

    test "create_store/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Planner.create_store(@invalid_attrs)
    end

    test "update_store/2 with valid data updates the store" do
      store = store_fixture()
      assert {:ok, store} = Planner.update_store(store, @update_attrs)
      assert %Store{} = store
      assert store.address == "some updated address"
      assert store.test_id == 43
    end

    test "update_store/2 with invalid data returns error changeset" do
      store = store_fixture()
      assert {:error, %Ecto.Changeset{}} = Planner.update_store(store, @invalid_attrs)
      assert store == Planner.get_store!(store.id)
    end

    test "delete_store/1 deletes the store" do
      store = store_fixture()
      assert {:ok, %Store{}} = Planner.delete_store(store)
      assert_raise Ecto.NoResultsError, fn -> Planner.get_store!(store.id) end
    end

    test "change_store/1 returns a store changeset" do
      store = store_fixture()
      assert %Ecto.Changeset{} = Planner.change_store(store)
    end
  end
end
