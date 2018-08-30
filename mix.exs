defmodule InetCidr.Mixfile do
  use Mix.Project

  def project do
    [app: :inet_cidr,
     version: "1.0.4",
     name: "InetCidr",
     source_url: "https://github.com/cobenian/inet_cidr",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:ex_doc, "~> 0.14", only: :dev}]
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
     maintainers: ["Bryan Weber"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/cobenian/inet_cidr"}]
  end
end
