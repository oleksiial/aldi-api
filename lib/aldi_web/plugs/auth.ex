defmodule AldiWeb.Plugs.Auth do
  import Plug.Conn

  def init(default), do: default

	def call(%Plug.Conn{req_headers: req_headers} = conn, _default) do
		cookie = req_headers
			|> List.keyfind("cookie", 0)
			|> elem(1)

		response = HTTPoison.get!(
      Aldi.Urls.new(),
      %{},
      hackney: [cookie: [cookie]]
		)
		
		case response.status_code do
			200 -> conn
			302 -> conn |> Phoenix.Controller.redirect(to: "/api/users") |> halt()
		end
		
	end
end