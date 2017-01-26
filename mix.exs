defmodule InetCidr.Mixfile do
  use Mix.Project

  def project do
    [app: :inet_cidr,
     version: "1.0.1",
     name: "InetCidr",
     source_url: "https://github.com/cobenian/inet_cidr",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.7", only: :dev}]
  end

  defp description do
    """
    Classless Inter-Domain Routing (CIDR) library for Elixir

    Compatible with Erlang's :inet module and support for IPv4 and IPv6
    """
  end

  defp package do
    [# These are the default files included in the package
     contributors: ["Bryan Weber"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/cobenian/inet_cidr"}]
  end
end
