defmodule NomemServer.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/hello" do
    send_resp(conn, 200, "hello")
  end

  get "/hitme/:size" do
    case Integer.parse(size) do
      {size, ""} ->
        reply =
          String.pad_trailing("", size, "My heart aches and a drowsy numbness pains my soul\n")

        send_resp(conn, 200, reply)

      _ ->
        send_resp(conn, 400, "size parameter not an integer")
    end
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
