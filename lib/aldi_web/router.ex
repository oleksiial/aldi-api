defmodule AldiWeb.Router do
  use AldiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug AldiWeb.Plugs.Auth
  end

  scope "/api", AldiWeb do
    pipe_through :api
    resources "/users", UserController, only: [:index, :create]
    
    pipe_through :authenticated
    resources "/users", UserController, except: [:new, :edit, :index, :create]
    get "/me", UserController, :me
  end
end
