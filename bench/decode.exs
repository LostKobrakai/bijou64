{list, _} = Code.eval_file("bench/_data.exs")

Benchee.run(
  %{
    "Varint: decode" => {
      fn list ->
        Enum.each(list, fn binary -> Varint.LEB128.decode(binary) end)
      end,
      before_scenario: fn input ->
        Enum.map(input, fn int -> Varint.LEB128.encode(int) end)
      end
    },
    "Bijou64: decode" => {
      fn list ->
        Enum.each(list, fn binary -> Bijou64.decode(binary) end)
      end,
      before_scenario: fn input ->
        Enum.map(input, fn int -> Bijou64.encode(int) end)
      end
    }
  },
  inputs: %{random_500: list}
)
