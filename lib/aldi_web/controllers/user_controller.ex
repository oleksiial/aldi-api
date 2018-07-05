defmodule AldiWeb.UserController do
  use AldiWeb, :controller

  alias Aldi.Account
  alias Aldi.Account.User
  alias Aldi.Planner

  action_fallback AldiWeb.FallbackController

  def me(%Plug.Conn{req_headers: req_headers} = conn, _params) do
    cookie = req_headers
			|> List.keyfind("cookie", 0)
      |> elem(1)
    
    user = Account.get_user_by_cookie(cookie)
    stores = Planner.fetch_stores(user)
    render(conn, "show.json", user: user)
  end

  def index(conn, _params) do
    users = Account.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, user_params) do
    case Account.get_user_by_email(Map.get(user_params, "email")) do
      nil -> with {:ok, %User{} = user} <- Account.create_user(user_params) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render("show.json", user: user)
      end
      user -> with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
        render(conn, "show.json", user: user)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Account.get_user!(id)

    with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    with {:ok, %User{}} <- Account.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
