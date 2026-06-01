defmodule Bijou64Test do
  use ExUnit.Case, async: true
  use ExUnitProperties
  import Bitwise

  doctest Bijou64

  property "symmetric" do
    check all int <- integer_generator() do
      assert int |> Bijou64.encode() |> Bijou64.decode() == {int, ""}
    end

    largest = 2 ** 64 - 1
    assert largest |> Bijou64.encode() |> Bijou64.decode() == {largest, ""}

    smallest = 0
    assert smallest |> Bijou64.encode() |> Bijou64.decode() == {smallest, ""}
  end

  describe "encode/1" do
    test "raises for out of bounds: negative number" do
      assert_raise FunctionClauseError, fn ->
        Bijou64.encode(-1)
      end
    end

    test "raises for out of bounds: too large" do
      assert_raise FunctionClauseError, fn ->
        Bijou64.encode(2 ** 64)
      end
    end
  end

  describe "decode/1" do
    test "raises for out of bounds: too large" do
      <<int::9*8>> = Bijou64.encode(2 ** 64 - 1)

      too_large = <<int + 1::9*8>>

      assert_raise FunctionClauseError, fn ->
        Bijou64.decode(too_large)
      end
    end

    property "raises for missing data" do
      check all int <- integer(0..(1 <<< 64)),
                binary = Bijou64.encode(int),
                length <- integer(0..(byte_size(binary) - 1)//1) do
        missing = binary_part(binary, 0, length)

        assert_raise FunctionClauseError, fn ->
          Bijou64.decode(missing)
        end
      end
    end
  end

  # Focus on edges between tiers, but leave all values possible
  defp integer_generator() do
    gen all {tier_min, tier_max} <- member_of(tiers()),
            integer <-
              one_of([
                constant(tier_min),
                constant(tier_max),
                integer(tier_min..tier_max)
              ]) do
      integer
    end
  end

  defp tiers do
    [
      0,
      0xF8,
      0x01F8,
      0x0101F8,
      0x010101F8,
      0x01010101F8,
      0x0101010101F8,
      0x010101010101F8,
      0x01010101010101F8
    ]
    |> Enum.chunk_every(2, 1, [2 ** 64])
    |> Enum.map(fn [a, b] -> {a, b - 1} end)
  end
end
