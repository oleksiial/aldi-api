defmodule AldiWeb.Router do
  use AldiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", AldiWeb do
    pipe_through :api
  end
end
