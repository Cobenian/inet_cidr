InetCidr
========

  Classless Inter-Domain Routing (CIDR) library for Elixir

This library has the following features:

* Compatible with Erlang's :inet module
* Supports IPv4 and IPv6

## Install

```elixir
defp deps do
  [
    {:inet_cidr, "~> 1.0.0"}
  ]
end
```

## Usage

### Parsing a CIDR string

```elixir
iex(1)> InetCidr.parse("192.168.0.0/16")
{{192,168,0,0}, {192,168,255,255}, 16}

iex(2)> InetCidr.parse("2001:abcd::/32")
{{8193, 43981, 0, 0, 0, 0, 0, 0}, {8193, 43981, 65535, 65535, 65535, 65535, 65535, 65535}, 32}
```

### Printing a CIDR block to string

```elixir
iex(1)> "192.168.0.0/16" |> InetCidr.parse |> InetCidr.to_string
"192.168.0.0/16"

iex(2)> "2001:abcd::/32" |> InetCidr.parse |> InetCidr.to_string
"2001:ABCD::/32"
```

### Check whether a CIDR block contains an IP address

```elixir
iex(1)> cidr = InetCidr.parse("192.168.0.0/16")
{{192,168,0,0}, {192,168,255,255}, 16}

iex(2)> address1 = InetCidr.parse_address!("192.168.15.20")
{192,168,15,20}

iex(3)> InetCidr.contains?(cidr, address1)
true

iex(4)> address2 = InetCidr.parse_address!("10.168.15.20")
{10,168,15,20}

iex(5)> InetCidr.contains?(cidr, address2)
false
```

```elixir
iex(1)> cidr = InetCidr.parse("2001:abcd::/32")
{{8193, 43981, 0, 0, 0, 0, 0, 0}, {8193, 43981, 65535, 65535, 65535, 65535, 65535, 65535}, 32}

iex(2)> address1 = InetCidr.parse_address!("2001:abcd::")
{8193, 43981, 0, 0, 0, 0, 0, 0}

iex(3)> InetCidr.contains?(cidr, address1)
true

iex(4)> address2 = InetCidr.parse_address!("abcd:2001::")
{43981, 8193, 0, 0, 0, 0, 0, 0}

iex(5)> InetCidr.contains?(cidr, address2)
false
```

## License

[LICENSE](LICENSE)
