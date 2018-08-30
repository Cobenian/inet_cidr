defmodule InetCidr do
  use Bitwise

  @moduledoc """
  Classless Inter-Domain Routing (CIDR) that is compatible with :inet and
  supports both IPv4 and IPv6
  """

  @doc """
  Parses a string containing either an IPv4 or IPv6 CIDR block using the
  notation like 192.168.0.0/16 or 2001:abcd::/32. It returns a tuple with the
  start address, end address and cidr length.

  You can optionally pass true as the second argument to adjust the start ip
  address if it is not consistent with the cidr length.
  For example, 192.168.0.0/0 would be adjusted to have a start ip of 0.0.0.0
  instead of 192.168.0.0. The default behavior is to be more strict and raise
  an exception when this occurs.
  """
  def parse(cidr_string, adjust \\ false) do
    {start_address,prefix_length} = parse_cidr!(cidr_string, adjust)
    end_address = calc_end_address(start_address, prefix_length)
    {start_address, end_address, prefix_length}
  end

  @doc """
  Prints the CIDR block to a string such that it can be parsed back to a CIDR
  block by this module.
  """
  def to_string({start_address, _end_address, cidr_length}) do
    "#{:inet.ntoa(start_address)}/#{cidr_length}"
  end

  @doc """
  Convenience function that takes an IPv4 or IPv6 address as a string and
  returns the address.  It raises an exception if the string does not contain
  a valid ip address.
  """
  def parse_address!(prefix) do
    {:ok, start_address} = prefix |> String.to_charlist |> :inet.parse_address
    start_address
  end

  @doc """
    The number of IP addresses included in the CIDR block.
  """
  def address_count(ip, len) do
    1 <<< (bit_count(ip)-len)
  end

  @doc """
  The number of bits in the address family (32 for IPv4 and 128 for IPv6)
  """
  def bit_count({_,_,_,_}), do: 32
  def bit_count({_,_,_,_,_,_,_,_}), do: 128

  @doc """
  Returns true if the CIDR block contains the IP address, false otherwise.
  """
  def contains?({{a,b,c,d}, {e,f,g,h}, _prefix_length}, {w,x,y,z}) do
    w in a..e and
    x in b..f and
    y in c..g and
    z in d..h
  end

  def contains?({{a,b,c,d,e,f,g,h}, {i,j,k,l,m,n,o,p}, _prefix_length}, {r,s,t,u,v,w,x,y}) do
    r in a..i and
    s in b..j and
    t in c..k and
    u in d..l and
    v in e..m and
    w in f..n and
    x in g..o and
    y in h..p
  end

  def contains?(_, _), do: false

  @doc """
    Returns true if the value passed in is an IPv4 address, false otherwise.
  """
  def v4?({a,b,c,d}) when a in 0..255 and b in 0..255 and c in 0..255 and d in 0..255, do: true
  def v4?(_), do: false

  @doc """
    Returns true if the value passed in is an IPv6 address, false otherwise.
  """
  def v6?({a,b,c,d,e,f,g,h}) when a in 0..65535 and b in 0..65535 and c in 0..65535 and d in 0..65535 and e in 0..65535 and f in 0..65535 and g in 0..65535 and h in 0..65535, do: true
  def v6?(_), do: false

  # internal functions

  defp parse_cidr!(cidr_string, adjust) do
    [prefix, prefix_length_str] = String.split(cidr_string, "/", parts: 2)
    start_address = parse_address!(prefix)
    {prefix_length,_} = Integer.parse(prefix_length_str)
    # if something 'nonsensical' is passed in like 192.168.0.0/0
    # we have three choices:
    # a) leave it alone (we do NOT allow this)
    # b) adjust the start ip (to 0.0.0.0 in this case) - when adjust == true
    # c) raise an exception - when adjust != true
    masked = band_with_mask(start_address, start_mask(start_address, prefix_length))
    if not adjust and masked != start_address do
      raise "Invalid CIDR: #{cidr_string}"
    end
    {masked,prefix_length}
  end

  defp calc_end_address(start_address,prefix_length) do
    bor_with_mask( start_address, end_mask(start_address, prefix_length) )
  end

  defp start_mask(s={_,_,_,_}, len) when len in 0..32 do
    {a,b,c,d} = end_mask(s,len)
    {bnot(a),bnot(b),bnot(c),bnot(d)}
  end

  defp start_mask(s={_,_,_,_,_,_,_,_}, len) when len in 0..128 do
    {a,b,c,d,e,f,g,h} = end_mask(s,len)
    {bnot(a),bnot(b),bnot(c),bnot(d),bnot(e),bnot(f),bnot(g),bnot(h)}
  end

  defp end_mask({_,_,_,_}, len) when len in 0..32 do
    cond do
      len == 32 -> {0,0,0,0}
      len >= 24 -> {0,0,0,bmask(len,8)}
      len >= 16 -> {0,0,bmask(len,8),0xFF}
      len >= 8  -> {0,bmask(len,8),0xFF,0xFF}
      len >= 0  -> {bmask(len,8),0xFF,0xFF,0xFF}
    end
  end

  defp end_mask({_,_,_,_,_,_,_,_}, len) when len in 0..128 do
    cond do
      len == 128 -> {0,0,0,0,0,0,0,0}
      len >= 112 -> {0,0,0,0,0,0,0,bmask(len,16)}
      len >= 96  -> {0,0,0,0,0,0,bmask(len,16),0xFFFF}
      len >= 80  -> {0,0,0,0,0,bmask(len,16),0xFFFF,0xFFFF}
      len >= 64  -> {0,0,0,0,bmask(len,16),0xFFFF,0xFFFF,0xFFFF}
      len >= 48  -> {0,0,0,bmask(len,16),0xFFFF,0xFFFF,0xFFFF,0xFFFF}
      len >= 32  -> {0,0,bmask(len,16),0xFFFF,0xFFFF,0xFFFF,0xFFFF,0xFFFF}
      len >= 16  -> {0,bmask(len,16),0xFFFF,0xFFFF,0xFFFF,0xFFFF,0xFFFF,0xFFFF}
      len >= 0   -> {bmask(len,16),0xFFFF,0xFFFF,0xFFFF,0xFFFF,0xFFFF,0xFFFF,0xFFFF}
    end
  end

  defp bmask(i,8) when i in 0..32 do
    0xFF >>> rem(i,8)
  end

  defp bmask(i,16) when i in 0..128 do
    0xFFFF >>> rem(i,16)
  end

  defp bor_with_mask( {a,b,c,d}, {e,f,g,h} ) do
    {bor(a,e),bor(b,f),bor(c,g),bor(d,h)}
  end

  defp bor_with_mask( {a,b,c,d,e,f,g,h}, {i,j,k,l,m,n,o,p} ) do
    {bor(a,i),bor(b,j),bor(c,k),bor(d,l),bor(e,m),bor(f,n),bor(g,o),bor(h,p)}
  end

  defp band_with_mask( {a,b,c,d}, {e,f,g,h} ) do
    {band(a,e),band(b,f),band(c,g),band(d,h)}
  end

  defp band_with_mask( {a,b,c,d,e,f,g,h}, {i,j,k,l,m,n,o,p} ) do
    {band(a,i),band(b,j),band(c,k),band(d,l),band(e,m),band(f,n),band(g,o),band(h,p)}
  end

end
