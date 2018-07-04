defmodule Aldi.Planner.Store do
  use Ecto.Schema
  import Ecto.Changeset


  schema "stores" do
    field :address, :string
    field :test_id, :integer
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(store, attrs) do
    store
    |> cast(attrs, [:address, :test_id])
    |> validate_required([:address, :test_id])
  end
end
