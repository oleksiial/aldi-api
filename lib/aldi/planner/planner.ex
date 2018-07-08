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

    rb = response.body
      |> String.replace("\r", "")
      |> String.replace("\n", "")
      |> String.replace("\t", "")
      |> String.replace("a>", "a>\r\n")

    ~r/<a href='(.*)' class.*Aldi.*Test ID ([0-9]+)<.*<\/a>/
      |> Regex.scan(rb)
      |> Enum.each(fn new_store ->
        case Aldi.Repo.get_by(Store, test_id: String.to_integer(Enum.at(new_store, 2))) do
        nil -> create_store(HTTPoison.get!(
          Enum.join([Aldi.Urls.singleRoot(), Enum.at(new_store, 1) |> String.replace("..", "")]),
          %{},
          hackney: [cookie: [user.cookie]]
        ).body, user.id)
        store -> nil
      end
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
  def create_store(attrs, user_id) do
    attrs = Store.parse_store(attrs)
    IO.inspect attrs
    %Store{}
    |> Store.changeset(attrs)
    |> Ecto.Changeset.put_change(:user_id, user_id)
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


# <a href="../project/project.php?code=MjMyMjMyNDk2MXwuLi9wcm9qZWN0L3Byb2plY3QucGhwP3Rlc3RpZD0yNTExOCZzdGF0dXM9NzAwJmFkZHJlc3M9Jmxvbj0mbGF0PSZwYWdlPQ==" class="list-group-item">
#   <h4> <span class="qs-icon-radio-unchecked" style="color:orange"></span> &nbsp;
#         <span class="text-mutedxx">neu</span>
#     </h4><div><strong>Aldi Kundenbarometer 2018 Juli SZ 1</strong></div><div>Aldi Nord 2018 Kundenbarometer </div><div style="margin-top:6px"><strong>Hamburg (Mümmelmannsberg)</strong></div><div class="text text-muted">Kandinskyallee 4-12 22115 Hamburg (Mümmelmannsberg) </div><div style="height:6px"></div><div>02.07.2018 - 12.07.2018 &nbsp; <small> <span class="text text-success"><strong>5</strong> verbleibende Tage</span> </small></div><div style="height:6px"></div>
#     <div class="row">
#     <div class="col-sm-4">
#         <div class="alert alert-warning" style="color:#222;">
#         <div><small>Vergütung:</small> <span class="text text-danger"><strong>12,00 EUR</strong></span> </div>
#         </div>
#       </div>
#   </div>
#         <div class="row">
#           <div class="col-sm-4">
#                 <div class="alert alert-success">
#                 <div><small class="text text-muted">Datum zur Durchführung des Tests </small></div>
#                   <div>
#                       <strong>Donnerstag &nbsp; 12.07.2018</strong>
#                   </div>
#             </div>
#         </div>
#       </div>
#   <br><div class="pull-right">Test ID 25118</div><br>
# </a>