defmodule Bijou64 do
  @moduledoc """
  Bijou64 is a purely canonical variable length encoding for u64 integers.

  Each integer can only be represented by a single encoded value, which aids
  security if the data is signed.

  See https://www.inkandswitch.com/tangents/bijou64/
  """
  @tier_offsets [
    0xF8,
    0x01F8,
    0x0101F8,
    0x010101F8,
    0x01010101F8,
    0x0101010101F8,
    0x010101010101F8,
    0x01010101010101F8
  ]

  @max_first_tier Enum.at(@tier_offsets, 0) - 1

  @typedoc """
  Valid integers are unsigned integers up to 64 bits.
  """
  @type u64 :: 0..0xFFFF_FFFF_FFFF_FFFF

  @doc """
  Encodes valid u64 integers according to the bujou64 format.
  """
  @spec encode(u64()) :: binary()
  def encode(int) when int in 0..@max_first_tier//1 do
    <<int::8>>
  end

  for {[offset, next], bytes} <-
        @tier_offsets
        |> Enum.chunk_every(2, 1, [2 ** 64])
        |> Enum.with_index(1) do
    def encode(int) when int in unquote(offset)..unquote(next - 1)//1 do
      <<
        unquote(@max_first_tier + bytes)::8,
        int - unquote(offset)::integer-size(unquote(bytes))-unit(8)
      >>
    end
  end

  @doc """
  Decodes valid u64 integers according to the bujou64 format from the start of a binary.
  """
  @spec decode(binary()) :: {u64(), binary()}
  def decode(<<int::8, rest::binary>>) when int in 0..@max_first_tier//1 do
    {int, rest}
  end

  for {offset, bytes} <- Enum.with_index(@tier_offsets, 1) do
    def decode(<<
          unquote(@max_first_tier + bytes)::8,
          num::integer-size(unquote(bytes))-unit(8),
          rest::binary
        >>) do
      {do_decode(num + unquote(offset), unquote(bytes)), rest}
    end
  end

  defp do_decode(total, 8) when total < unquote(2 ** 64), do: total
  defp do_decode(total, bytes) when bytes < 8, do: total
end
