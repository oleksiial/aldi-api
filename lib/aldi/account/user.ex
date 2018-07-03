defmodule Aldi.Account.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :cookie, :string
    field :email, :string, null: false
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    IO.inspect attrs
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> get_cookie()
  end

  defp get_cookie(%Ecto.Changeset{changes: %{email: email, password: password}} = user) do
    body = "user=#{email}&pass=#{password}&cid=58&qlang=de"
    IO.inspect body
    response = HTTPoison.post!(
      "https://www.bonsai-mystery.com/qm/quest/app/login/login_a.php",
      body
    )
    IO.inspect response
    user
  end
end
