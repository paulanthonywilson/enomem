defmodule NomemServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @port if :test == Mix.env(), do: 4124, else: 4123

  @impl true
  def start(_type, _args) do
    children = [
      {Bandit, plug: NomemServer.Router, port: @port}
    ]

    opts = [strategy: :one_for_one, name: NomemServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
