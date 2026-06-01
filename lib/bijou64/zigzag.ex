defmodule Bijou64.Zigzag do
  @moduledoc """
  Zigzag mapping between signed and unsigned integers.

  Interleaves positive and negative numbers so that small-magnitude values
  map to small unsigned values:
  0 → 0, -1 → 1, 1 → 2, -2 → 3, 2 → 4, …

  Works on arbitrary-precision Elixir integers.
  """
  import Integer, only: [is_even: 1]

  @doc """
  Maps a signed integer to a non-negative integer.

      iex> Bijou64.Zigzag.to_unsigned(0)
      0

      iex> Bijou64.Zigzag.to_unsigned(-1)
      1

      iex> Bijou64.Zigzag.to_unsigned(1)
      2

      iex> Bijou64.Zigzag.to_unsigned(-2)
      3

  """
  @spec to_unsigned(integer()) :: non_neg_integer()
  def to_unsigned(n) when is_integer(n) and n >= 0, do: n * 2
  def to_unsigned(n) when is_integer(n), do: n * -2 - 1

  @doc """
  Maps a non-negative integer back to a signed integer.

      iex> Bijou64.Zigzag.from_unsigned(0)
      0

      iex> Bijou64.Zigzag.from_unsigned(1)
      -1

      iex> Bijou64.Zigzag.from_unsigned(2)
      1

      iex> Bijou64.Zigzag.from_unsigned(3)
      -2

  """
  @spec from_unsigned(non_neg_integer()) :: integer()
  def from_unsigned(n) when is_even(n) and n >= 0, do: div_2(n)
  def from_unsigned(n) when is_integer(n) and n >= 0, do: -(div_2(n + 1))

  @compile {:inline, div_2: 1}
  defp div_2(a), do: Bitwise.bsr(a, 1)
end
