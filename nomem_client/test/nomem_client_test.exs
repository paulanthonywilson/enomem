defmodule NomemClientTest do
  use ExUnit.Case
  import Mimic

  setup :verify_on_exit!

  test "mb" do
    assert NomemClient.mb(1) == 1_000_000
  end

  describe "poison" do
    test "successful get returns size ok and size of body" do
      expect(HTTPoison, :get, fn url ->
        assert url == "http://localhost:4123/hitme/100"
        {:ok, %HTTPoison.Response{status_code: 200, body: "0123456789"}}
      end)

      assert {:ok, 10} = NomemClient.httpoison(100)
    end

    test "on failure returns the error" do
      stub(HTTPoison, :get, fn _ ->
        {:error, %HTTPoison.Error{reason: :enomem, id: nil}}
      end)

      assert {:error, %{reason: :enomem}} = NomemClient.httpoison(10)
    end
  end

  describe "curl" do
    test "ok returns with the size of the response" do
      expect(System, :cmd, fn cmd, args ->
        assert cmd == "curl"
        assert ["http://localhost:4123/hitme/11"] == args
        {"0123", 0}
      end)

      assert {:ok, 4} = NomemClient.curl(11)
    end

    test "error" do
      stub(System, :cmd, fn _, _ -> {"nope", 7} end)

      assert {:error, "nope"} == NomemClient.curl(1)
    end
  end

  describe "finch" do
    test "ok returns with the size of the response" do
      Finch
      |> expect(:build, fn method, url ->
        assert method == :get
        assert url == "http://localhost:4123/hitme/9"
        "the url"
      end)
      |> expect(:request, fn built, Finchy ->
        assert "the url" == built
        {:ok, %Finch.Response{status: 200, body: "hello"}}
      end)

      assert {:ok, 5} == NomemClient.finch(9)
    end

    test "full finch response if not a 200" do
      Finch
      |> stub(:build, fn _, _ ->
        "the url"
      end)
      |> stub(:request, fn _, _ ->
        {:ok, %Finch.Response{status: 400, body: "hello"}}
      end)

      assert {:ok, %{status: 400}} = NomemClient.finch(11)
    end

    test "error for error response" do
      Finch
      |> stub(:build, fn _, _ ->
        "the url"
      end)
      |> stub(:request, fn _, _ ->
        {:error, :oh_noes}
      end)

      assert {:error, :oh_noes} = NomemClient.finch(11)
    end
  end
end
