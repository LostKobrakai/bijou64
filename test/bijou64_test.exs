defmodule Bijou64Test do
  use ExUnit.Case, async: true
  use ExUnitProperties
  import Bitwise

  doctest Bijou64

  property "symmetric" do
    check all int <- integer(0..(1 <<< 64)) do
      assert int |> Bijou64.encode() |> Bijou64.decode() == {int, ""}
    end
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
end
