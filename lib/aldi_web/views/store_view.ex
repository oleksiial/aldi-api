defmodule AldiWeb.StoreView do
  use AldiWeb, :view
  alias AldiWeb.StoreView

  def render("index.json", %{stores: stores}) do
    %{data: render_many(stores, StoreView, "store.json")}
  end

  def render("show.json", %{store: store}) do
    %{data: render_one(store, StoreView, "store.json")}
  end

  def render("store.json", %{store: store}) do
    %{id: store.id,
      address: store.address,
      test_id: store.test_id,
      is_done: store.is_done
    }
  end
end
