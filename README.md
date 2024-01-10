# InetCidr

<!-- MDOC !-->

[![Module Version](https://img.shields.io/hexpm/v/inet_cidr.svg)](https://hex.pm/packages/inet_cidr)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/inet_cidr/)
[![Total Download](https://img.shields.io/hexpm/dt/inet_cidr.svg)](https://hex.pm/packages/inet_cidr)
[![License](https://img.shields.io/hexpm/l/inet_cidr.svg)](https://github.com/cobenian/inet_cidr/blob/master/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/cobenian/inet_cidr.svg)](https://github.com/cobenian/inet_cidr/commits/master)

Classless Inter-Domain Routing (CIDR) library for Elixir that is compatible
with Erlang's `:inet` and supports both IPv4 and IPv6.

## Install

Add `:inet_cidr` to your list of dependencies in `mix.exs`:

```elixir
defp deps do
  [
    {:inet_cidr, "~> 1.0.0"}
  ]
end
```

## Usage

### Parsing a CIDR string (IPv4 or IPv6)

```elixir
iex> InetCidr.parse_cidr("192.168.0.0/16")
{:ok, {{192,168,0,0}, {192,168,255,255}, 16}}

iex> InetCidr.parse_cidr!("192.168.0.0/16")
{{192,168,0,0}, {192,168,255,255}, 16}

iex> InetCidr.parse_cidr("2001:abcd::/32")
{:ok, {{8193, 43981, 0, 0, 0, 0, 0, 0}, {8193, 43981, 65535, 65535, 65535, 65535, 65535, 65535}, 32}}

iex> InetCidr.parse_cidr!("2001:abcd::/32")
{{8193, 43981, 0, 0, 0, 0, 0, 0}, {8193, 43981, 65535, 65535, 65535, 65535, 65535, 65535}, 32}
```

### Printing a CIDR block to string

```elixir
iex> "192.168.0.0/16" |> InetCidr.parse_cidr! |> InetCidr.to_string
"192.168.0.0/16"

iex> "2001:abcd::/32" |> InetCidr.parse_cidr! |> InetCidr.to_string
"2001:ABCD::/32"
```

### Check whether a CIDR block contains an IP address

There are also `parse_cidr/1` and `parse_address/1` versions that return `{:ok,_cidr}` and `{:error,_msg}` tuples.

#### IPv4

```elixir
iex> cidr = InetCidr.parse_cidr!("192.168.0.0/16")
{{192,168,0,0}, {192,168,255,255}, 16}

iex> address1 = InetCidr.parse_address!("192.168.15.20")
{192,168,15,20}

iex> InetCidr.contains?(cidr, address1)
true

iex> address2 = InetCidr.parse_address!("10.168.15.20")
{10,168,15,20}

iex> InetCidr.contains?(cidr, address2)
false
```

#### IPv6

```elixir
iex> cidr = InetCidr.parse_cidr!("2001:abcd::/32")
{{8193, 43981, 0, 0, 0, 0, 0, 0}, {8193, 43981, 65535, 65535, 65535, 65535, 65535, 65535}, 32}

iex> address1 = InetCidr.parse_address!("2001:abcd::")
{8193, 43981, 0, 0, 0, 0, 0, 0}

iex> InetCidr.contains?(cidr, address1)
true

iex> address2 = InetCidr.parse_address!("abcd:2001::")
{43981, 8193, 0, 0, 0, 0, 0, 0}

iex> InetCidr.contains?(cidr, address2)
false
```

### Get the end of a CIDR block

```elixir
iex> InetCidr.calc_end_address({192, 168, 0, 0}, 16)
{:ok, {192, 168, 255, 255}}

iex> InetCidr.calc_end_address!({192, 168, 0, 0}, 16)
{192, 168, 255, 255}
```

## License

Copyright (c) 2015-2024 Cobenian and Bryan Weber

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
