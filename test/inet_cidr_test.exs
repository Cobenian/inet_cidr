defmodule InetCidrTest do
  use ExUnit.Case

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "parse_cidr works with :ok/:error tuples" do
    assert InetCidr.parse_cidr("192.168.0.0/0", true) ==
             {:ok, {{0, 0, 0, 0}, {255, 255, 255, 255}, 0}}

    assert InetCidr.parse_cidr("192.168.0.0/2") ==
             {:error, %RuntimeError{message: "Invalid CIDR: 192.168.0.0/2"}}
  end

  test "can parse ipv4 cidr block" do
    assert InetCidr.parse_cidr!("192.168.0.0/0", true) == {{0, 0, 0, 0}, {255, 255, 255, 255}, 0}

    assert InetCidr.parse_cidr!("192.168.0.0/8", true) ==
             {{192, 0, 0, 0}, {192, 255, 255, 255}, 8}

    assert InetCidr.parse_cidr!("192.168.0.0/15", true) ==
             {{192, 168, 0, 0}, {192, 169, 255, 255}, 15}

    assert InetCidr.parse_cidr!("192.168.0.0/16") == {{192, 168, 0, 0}, {192, 168, 255, 255}, 16}
    assert InetCidr.parse_cidr!("192.168.0.0/17") == {{192, 168, 0, 0}, {192, 168, 127, 255}, 17}
    assert InetCidr.parse_cidr!("192.168.0.0/18") == {{192, 168, 0, 0}, {192, 168, 63, 255}, 18}
    assert InetCidr.parse_cidr!("192.168.0.0/19") == {{192, 168, 0, 0}, {192, 168, 31, 255}, 19}
    assert InetCidr.parse_cidr!("192.168.0.0/20") == {{192, 168, 0, 0}, {192, 168, 15, 255}, 20}
    assert InetCidr.parse_cidr!("192.168.0.0/21") == {{192, 168, 0, 0}, {192, 168, 7, 255}, 21}
    assert InetCidr.parse_cidr!("192.168.0.0/22") == {{192, 168, 0, 0}, {192, 168, 3, 255}, 22}
    assert InetCidr.parse_cidr!("192.168.0.0/23") == {{192, 168, 0, 0}, {192, 168, 1, 255}, 23}
    assert InetCidr.parse_cidr!("192.168.0.0/24") == {{192, 168, 0, 0}, {192, 168, 0, 255}, 24}
    assert InetCidr.parse_cidr!("192.168.0.0/31") == {{192, 168, 0, 0}, {192, 168, 0, 1}, 31}
    assert InetCidr.parse_cidr!("192.168.0.0/32") == {{192, 168, 0, 0}, {192, 168, 0, 0}, 32}

    assert_raise(
      RuntimeError,
      "Invalid CIDR: 192.168.0.0/2",
      fn ->
        InetCidr.parse_cidr!("192.168.0.0/2")
      end
    )
  end

  test "can parse ipv6 cidr block" do
    assert InetCidr.parse_cidr!("2001:abcd::/0", true) ==
             {{0, 0, 0, 0, 0, 0, 0, 0}, {65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535},
              0}

    assert InetCidr.parse_cidr!("2001:abcd::/32") ==
             {{8193, 43981, 0, 0, 0, 0, 0, 0},
              {8193, 43981, 65535, 65535, 65535, 65535, 65535, 65535}, 32}

    assert InetCidr.parse_cidr!("2001:abcd::/33") ==
             {{8193, 43981, 0, 0, 0, 0, 0, 0},
              {8193, 43981, 32767, 65535, 65535, 65535, 65535, 65535}, 33}

    assert InetCidr.parse_cidr!("2001:abcd::/34") ==
             {{8193, 43981, 0, 0, 0, 0, 0, 0},
              {8193, 43981, 16383, 65535, 65535, 65535, 65535, 65535}, 34}

    assert InetCidr.parse_cidr!("2001:abcd::/35") ==
             {{8193, 43981, 0, 0, 0, 0, 0, 0},
              {8193, 43981, 8191, 65535, 65535, 65535, 65535, 65535}, 35}

    assert InetCidr.parse_cidr!("2001:abcd::/36") ==
             {{8193, 43981, 0, 0, 0, 0, 0, 0},
              {8193, 43981, 4095, 65535, 65535, 65535, 65535, 65535}, 36}

    assert InetCidr.parse_cidr!("2001:abcd::/128") ==
             {{8193, 43981, 0, 0, 0, 0, 0, 0}, {8193, 43981, 0, 0, 0, 0, 0, 0}, 128}

    assert InetCidr.parse_cidr!("2001:db8::/48") ==
             {{8193, 3512, 0, 0, 0, 0, 0, 0}, {8193, 3512, 0, 65535, 65535, 65535, 65535, 65535},
              48}
  end

  test "printing cidr block to string" do
    assert InetCidr.to_string({{192, 168, 0, 0}, {192, 168, 255, 255}, 16}) == "192.168.0.0/16"

    assert InetCidr.to_string({
             {8193, 43981, 0, 0, 0, 0, 0, 0},
             {8193, 43981, 65535, 65535, 65535, 65535, 65535, 65535},
             32
           })
           |> String.upcase() == "2001:ABCD::/32"
  end

  test "can parse ipv4 address" do
    assert InetCidr.parse_address("76.58.129.251") == {:ok, {76, 58, 129, 251}}

    assert InetCidr.parse_address("76.58.abc.251") ==
             {:error, %RuntimeError{message: "Invalid address: 76.58.abc.251"}}

    assert InetCidr.parse_address!("76.58.129.251") == {76, 58, 129, 251}

    assert_raise(
      RuntimeError,
      "Invalid address: 76.58.abc.256",
      fn ->
        InetCidr.parse_address!("76.58.abc.256")
      end
    )
  end

  test "can parse ipv6 address" do
    assert InetCidr.parse_address!("2001:abcd::") == {8193, 43981, 0, 0, 0, 0, 0, 0}
    assert InetCidr.parse_address!("1:abcd::4") == {1, 43981, 0, 0, 0, 0, 0, 4}

    assert_raise(
      RuntimeError,
      "Invalid address: 1:vwxyz::4",
      fn ->
        InetCidr.parse_address!("1:vwxyz::4")
      end
    )
  end

  test "correct address count for ipv4 cidr block" do
    v4address = {192, 168, 0, 0}
    assert InetCidr.address_count(v4address, 0) == 4_294_967_296
    assert InetCidr.address_count(v4address, 16) == 65536
    assert InetCidr.address_count(v4address, 17) == 32768
    assert InetCidr.address_count(v4address, 24) == 256
    assert InetCidr.address_count(v4address, 32) == 1
  end

  test "correct address count for ipv6 cidr block" do
    v6address = InetCidr.parse_address!("2001::abcd")
    assert InetCidr.address_count(v6address, 0) == :math.pow(2, 128)
    assert InetCidr.address_count(v6address, 64) == :math.pow(2, 64)
    assert InetCidr.address_count(v6address, 128) == 1
  end

  test "is ipv4 address?" do
    assert InetCidr.v4?({192, 168, 0, 0}) == true
    assert InetCidr.v4?({192, 168, 0, 256}) == false
    assert InetCidr.v4?({192, 168, 0}) == false
    assert InetCidr.v4?({192, 168, 0, 0, 0}) == false
    assert InetCidr.v4?(InetCidr.parse_address!("2001::abcd")) == false
  end

  test "is ipv6 address?" do
    assert InetCidr.v6?({8193, 43981, 0, 0, 0, 0, 0, 0}) == true
    assert InetCidr.v6?({192, 168, 0, 0}) == false
    assert InetCidr.v6?({8193, 43981, 0, 0, 0, 0, 0, 70000}) == false
    assert InetCidr.v6?({8193, 43981, 0, 0, 0, 0, 0}) == false
    assert InetCidr.v6?({8193, 43981, 0, 0, 0, 0, 0, 0, 0}) == false
  end

  test "ipv4 block contains address?" do
    block = {{192, 168, 0, 0}, {192, 168, 255, 255}, 16}
    assert InetCidr.contains?(block, {192, 168, 0, 0}) == true
    assert InetCidr.contains?(block, {192, 168, 0, 1}) == true
    assert InetCidr.contains?(block, {192, 168, 1, 0}) == true
    assert InetCidr.contains?(block, {192, 168, 0, 255}) == true
    assert InetCidr.contains?(block, {192, 168, 255, 0}) == true
    assert InetCidr.contains?(block, {192, 168, 255, 255}) == true
    assert InetCidr.contains?(block, {192, 168, 255, 256}) == false
    assert InetCidr.contains?(block, {192, 169, 0, 0}) == false
    assert InetCidr.contains?(block, {192, 167, 255, 255}) == false
  end

  test "ipv6 block contains address?" do
    block =
      {
        {8193, 43981, 0, 0, 0, 0, 0, 0},
        {8193, 43981, 8191, 65535, 65535, 65535, 65535, 65535},
        35
      }

    assert InetCidr.contains?(block, {8193, 43981, 0, 0, 0, 0, 0, 0}) == true
    assert InetCidr.contains?(block, {8193, 43981, 0, 0, 0, 0, 0, 1}) == true

    assert InetCidr.contains?(block, {8193, 43981, 8191, 65535, 65535, 65535, 65535, 65534}) ==
             true

    assert InetCidr.contains?(block, {8193, 43981, 8191, 65535, 65535, 65535, 65535, 65535}) ==
             true

    assert InetCidr.contains?(block, {8193, 43981, 8192, 65535, 65535, 65535, 65535, 65535}) ==
             false

    assert InetCidr.contains?(block, {65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535}) ==
             false
  end

  test "get the end of a CIDR block" do
    assert InetCidr.calc_end_address({192, 168, 0, 0}, 16) == {:ok, {192, 168, 255, 255}}
    assert InetCidr.calc_end_address!({192, 168, 0, 0}, 4) == {207, 255, 255, 255}

    assert InetCidr.calc_end_address({192, 168, 0, 0}, 409) ==
             {:error, %FunctionClauseError{module: InetCidr, function: :end_mask, arity: 2}}

    assert_raise(
      FunctionClauseError,
      fn ->
        InetCidr.calc_end_address!({192, 168, 0, 0}, 409)
      end
    )
  end
end
