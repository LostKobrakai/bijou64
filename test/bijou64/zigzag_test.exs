defmodule Bijou64.ZigzagTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  import Integer, only: [is_even: 1, is_odd: 1]

  doctest Bijou64.Zigzag

  property "symmetric" do
    check all int <- integer() do
      assert int |> Bijou64.Zigzag.to_unsigned() |> Bijou64.Zigzag.from_unsigned() == int
    end
  end

  property "to_unsigned always returns non-negative" do
    check all int <- integer() do
      assert Bijou64.Zigzag.to_unsigned(int) >= 0
    end
  end

  describe "to_unsigned/1" do
    property "maps non-negative integers to even, negative to odd" do
      check all int <- integer() do
        unsigned = Bijou64.Zigzag.to_unsigned(int)

        if int >= 0 do
          assert is_even(unsigned)
        else
          assert is_odd(unsigned)
        end
      end
    end

    test "raises for non-integer" do
      assert_raise FunctionClauseError, fn -> Bijou64.Zigzag.to_unsigned(1.0) end
    end
  end

  describe "from_unsigned/1" do
    test "raises for negative input" do
      assert_raise FunctionClauseError, fn -> Bijou64.Zigzag.from_unsigned(-1) end
    end

    test "raises for non-integer" do
      assert_raise FunctionClauseError, fn -> Bijou64.Zigzag.from_unsigned(1.0) end
    end
  end
end
