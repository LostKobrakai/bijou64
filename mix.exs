defmodule Bijou64.MixProject do
  use Mix.Project

  def project do
    [
      app: :bijou64,
      version: "0.1.2",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "Bijou64",
      source_url: "https://github.com/LostKobrakai/bijou64"
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
      {:benchee, "~> 1.0", only: [:dev, :test]},
      {:varint, "~> 1.0", only: [:dev, :test]},
      {:beam_file, "~> 0.6", only: :dev},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false, warn_if_outdated: true},
      {:stream_data, "~> 1.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp description() do
    "Bijou64 is a purely canonical variable length encoding for u64 integers."
  end

  defp package() do
    [
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/LostKobrakai/bijou64"}
    ]
  end
end
