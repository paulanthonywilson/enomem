defmodule NomemServer.RouterTest do
  use ExUnit.Case, async: true
  alias NomemServer.Router

  use Plug.Test

  @opts []

  test "get /hello returns hello" do
    conn = conn(:get, "/hello")
    conn = Router.call(conn, @opts)
    assert 200 == conn.status
    assert "hello" == conn.resp_body
  end

  test "unknown route returns 404" do
    conn =
      :get
      |> conn("/wibble")
      |> Router.call(@opts)

    assert 404 == conn.status
  end

  describe("/hitme/:size") do
    test "returns a response with a body of the requested size" do
      conn =
        :get
        |> conn("/hitme/1500")
        |> Router.call(@opts)

      assert 200 = conn.status
      assert 1_500 = byte_size(conn.resp_body)
    end

    test "400 if the size is not an integer" do
      conn =
        :get
        |> conn("/hitme/15.24")
        |> Router.call(@opts)

      assert 400 = conn.status
    end
  end
end
