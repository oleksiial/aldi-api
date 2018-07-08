defmodule AldiWeb.Plugs.Auth do
  import Plug.Conn

  def init(default), do: default

	def call(%Plug.Conn{req_headers: req_headers} = conn, _default) do
		cookie = req_headers
			|> List.keyfind("cookie", 0)
		
		case verify_cookie(cookie) do
			true -> conn
			false -> conn |> Phoenix.Controller.redirect(to: "/api/users") |> halt()
		end
	end

	defp verify_cookie(nil), do: false
	defp verify_cookie(cookie) do
		cookie = elem(cookie, 1)
		response = HTTPoison.get!(
      Aldi.Urls.new(),
      %{},
      hackney: [cookie: [cookie]]
		)
		case response.status_code do
			200 -> true
			302 -> false
		end
	end
end