defmodule AldiWeb.StoreController do
  use AldiWeb, :controller

  alias Aldi.Planner
  alias Aldi.Planner.Store

  action_fallback AldiWeb.FallbackController

  def index(conn, _params) do
    stores = Planner.list_stores()
    render(conn, "index.json", stores: stores)
  end

  def show(conn, %{"id" => id}) do
    store = Planner.get_store!(id)
    render(conn, "show.json", store: store)
  end

  def update(conn, %{"id" => id, "store" => store_params}) do
    store = Planner.get_store!(id)

    with {:ok, %Store{} = store} <- Planner.update_store(store, store_params) do
      render(conn, "show.json", store: store)
    end
  end

  def delete(conn, %{"id" => id}) do
    store = Planner.get_store!(id)
    with {:ok, %Store{}} <- Planner.delete_store(store) do
      send_resp(conn, :no_content, "")
    end
  end
end
