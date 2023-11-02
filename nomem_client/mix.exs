defmodule NomemClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :nomem_client,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :runtime_tools],
      mod: {NomemClient.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison,
       git: "https://github.com/paulanthonywilson/httpoison.git", branch: "better-stack-traces"},
      {:finch, "~> 0.16"},
      #
      {:mimic, "~> 1.7", only: :test},
      #
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test]},
      {:recon, "~> 2.5"}
    ]
  end
end
