defmodule Speakers.MixProject do
  use Mix.Project

  def project do
    [
      app: :speakers,
      version: "0.2.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      name: "speakers",
      description: description(),
      package: package(),
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rustler_precompiled, "~> 0.6.0"},
      {:rustler, ">= 0.0.0", optional: true},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp description do
    """
    Library for playing remote audio files
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Raza Gill"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/paulgoetze/speakers"}
    ]
  end

  defp aliases do
    [
      # always force building the NIF for test runs:
      test: [fn _ -> System.put_env("SPEAKERS_BUILD", "true") end, "test"]
    ]
  end
end
