defmodule Aldi.Account.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :cookie, :string
    field :email, :string, null: false
    field :password, :string, virtual: true

    has_many :stores, Aldi.Planner.Store

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> get_cookie(attrs)
    |> validate_required([:cookie])
  end

  defp get_cookie(user, attrs) do
    headers = HTTPoison.post!(
      Aldi.Urls.login(),
      {
          :form, [
            user: Map.get(attrs, "email"),
            pass: Map.get(attrs, "password"),
            cid: "58",
            qlang: "de"
          ]
      }
    ).headers

    loc = List.keyfind(headers, "Location", 0) |> elem(1)
    if loc == "../main/main_m.php" do
      cookie = List.keyfind(headers, "Set-Cookie", 0)
      cookie = ~r/^(.*);/
        |> Regex.run(elem(cookie, 1))
        |> Enum.at(1)

      %Ecto.Changeset{user | changes: Map.put(user.changes, :cookie, cookie)}
    else
      %Ecto.Changeset{user | valid?: false}
    end
  end
end
