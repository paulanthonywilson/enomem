defmodule NomemClient do
  @moduledoc false

  # defguardp non_neg_integer()

  @doc """
  SI megabytes (1mb is a million bytes)
  """
  @spec mb(non_neg_integer()) :: non_neg_integer()
  def mb(bytes), do: bytes * 1_000_000

  @doc """
  Calls the server, requesting a payload with a body of
  the size requested. Returns ok with the size returned, or error
  """
  @spec httpoison(body_size :: integer()) :: {:ok, size :: non_neg_integer()} | {:error, term()}
  def httpoison(body_size) when is_integer(body_size) and body_size > -1 do
    body_size
    |> url()
    |> HTTPoison.get()
    |> case do
      {:ok, %{status_code: 200, body: body}} -> {:ok, byte_size(body)}
      err -> err
    end
  end

  def curl(body_size) do
    "curl"
    |> System.cmd([url(body_size)])
    |> case do
      {response, 0} ->
        {:ok, byte_size(response)}

      {response, _} ->
        {:error, response}
    end
  end

  def finch(body_size) do
    :get
    |> Finch.build(url(body_size))
    |> Finch.request(Finchy)
    |> case do
      {:ok, %{status: 200, body: body}} ->
        {:ok, byte_size(body)}

      err ->
        err
    end
  end

  defp url(body_size), do: "http://localhost:4123/hitme/#{body_size}"
end
