defmodule Aldi.Planner do
  @moduledoc """
  The Planner context.
  """

  import Ecto.Query, warn: false
  alias Aldi.Repo

  alias Aldi.Planner.Store
  alias Aldi.Account.User

  def fetch_stores(user) do
		response = HTTPoison.get!(
      Aldi.Urls.new(),
      %{},
      hackney: [cookie: [user.cookie]]
    )
    new_stores = ~r/href='..\/(.*)' class='list-group-item/
      |> Regex.scan(response.body)
      |> Enum.map(&Enum.at(&1, 1))
      |> Enum.each(fn store_link ->
        response = HTTPoison.get!(
          Enum.join([Aldi.Urls.singleRoot(), store_link]),
          %{},
          hackney: [cookie: [user.cookie]]
        )
        test_id =
          ~r/Test ID: ([0-9]+)/
          |> Regex.run(response.body)
          |> Enum.at(1)
          |> String.to_integer()
          
        IO.inspect test_id
        # TODO create new store and assign it to the user
      end)
    user
  end

  @doc """
  Returns the list of stores.

  ## Examples

      iex> list_stores()
      [%Store{}, ...]

  """
  def list_stores do
    Repo.all(Store)
  end

  @doc """
  Gets a single store.

  Raises `Ecto.NoResultsError` if the Store does not exist.

  ## Examples

      iex> get_store!(123)
      %Store{}

      iex> get_store!(456)
      ** (Ecto.NoResultsError)

  """
  def get_store!(id), do: Repo.get!(Store, id)

  @doc """
  Creates a store.

  ## Examples

      iex> create_store(%{field: value})
      {:ok, %Store{}}

      iex> create_store(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_store(attrs \\ %{}) do
    %Store{}
    |> Store.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a store.

  ## Examples

      iex> update_store(store, %{field: new_value})
      {:ok, %Store{}}

      iex> update_store(store, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_store(%Store{} = store, attrs) do
    store
    |> Store.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Store.

  ## Examples

      iex> delete_store(store)
      {:ok, %Store{}}

      iex> delete_store(store)
      {:error, %Ecto.Changeset{}}

  """
  def delete_store(%Store{} = store) do
    Repo.delete(store)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking store changes.

  ## Examples

      iex> change_store(store)
      %Ecto.Changeset{source: %Store{}}

  """
  def change_store(%Store{} = store) do
    Store.changeset(store, %{})
  end
end
